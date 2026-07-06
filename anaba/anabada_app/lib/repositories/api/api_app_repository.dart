import '../../models/app_notification.dart';
import '../../models/item_comment.dart';
import '../../models/notice.dart';
import '../../models/trade_item.dart';
import '../../models/trade_request.dart';
import '../../services/api/api_client.dart';
import '../../services/api/api_response.dart';
import '../../services/api/account_api.dart';
import '../../services/api/comment_api.dart';
import '../../services/api/like_api.dart';
import '../../services/api/notice_api.dart';
import '../../services/api/post_api.dart';
import '../app_repository.dart';
import 'mappers/item_comment_mapper.dart';
import 'mappers/notice_mapper.dart';
import 'mappers/trade_item_mapper.dart';

typedef CurrentUserIdProvider = String? Function();

class ApiAppRepository implements AppRepository {
  ApiAppRepository(ApiClient apiClient, {this.currentUserIdProvider})
    : _accountApi = AccountApi(apiClient),
      _postApi = PostApi(apiClient),
      _commentApi = CommentApi(apiClient),
      _likeApi = LikeApi(apiClient),
      _noticeApi = NoticeApi(apiClient);

  final AccountApi _accountApi;
  final PostApi _postApi;
  final CommentApi _commentApi;
  final LikeApi _likeApi;
  final NoticeApi _noticeApi;
  final CurrentUserIdProvider? currentUserIdProvider;

  final List<TradeItem> _items = [];
  final List<ItemComment> _comments = [];
  final List<Notice> _notices = [];
  final Map<String, List<String>> _recentItemIds = {};
  int _idCounter = 0;

  @override
  List<TradeItem> get cachedItems => List.unmodifiable(_items);

  @override
  List<ItemComment> get cachedComments => List.unmodifiable(_comments);

  @override
  List<AppNotification> get cachedNotifications => const [];

  @override
  List<Notice> get cachedNotices => List.unmodifiable(_notices);

  @override
  List<TradeRequest> get cachedRequests => const [];

  @override
  List<String> recentItemIdsFor(String userId) {
    return List.unmodifiable(_recentItemIds[userId] ?? const []);
  }

  @override
  Future<void> refresh() async {
    await fetchPosts();
    await fetchNotices();
  }

  Future<List<TradeItem>> fetchPosts() async {
    final ApiResponse<List<TradeItem>> response = await _postApi.fetchAll(
      (json) => _mapTradeItem(json),
    );
    final List<TradeItem> items = response.data;

    _items
      ..clear()
      ..addAll(items);
    _syncCommentsFromPosts(response.raw);
    return List.unmodifiable(items);
  }

  @override
  Future<List<TradeItem>> fetchUserItems(String userId) async {
    final ApiResponse<List<TradeItem>> response = await _accountApi.fetchPosts(
      (json) => _mapTradeItem(json),
    );
    final List<TradeItem> items = response.data;
    final Set<String> fetchedIds = items.map((item) => item.id).toSet();

    _items.removeWhere(
      (item) => item.ownerId == userId && !fetchedIds.contains(item.id),
    );

    for (final TradeItem item in items) {
      _upsertItem(item);
    }

    return List.unmodifiable(items);
  }

  Future<TradeItem> fetchPost(String productId) async {
    final ApiResponse<TradeItem> response = await _postApi.fetchOne(
      productId,
      (json) => _mapTradeItem(json),
    );
    final TradeItem item = response.data;
    _upsertItem(item);
    _syncCommentsFromPosts(response.raw);
    return item;
  }

  Future<List<TradeItem>> fetchRecentPosts() async {
    final ApiResponse<List<TradeItem>> response = await _postApi.fetchRecent(
      (json) => _mapTradeItem(json),
    );
    final List<TradeItem> items = response.data;

    for (final TradeItem item in items) {
      _upsertItem(item);
    }

    final String userId = currentUserIdProvider?.call() ?? '';
    if (userId.isNotEmpty) {
      _recentItemIds[userId] = items.map((item) => item.id).toList();
    }
    return List.unmodifiable(items);
  }

  @override
  Future<TradeItem> createItem(CreateTradeItemInput input) async {
    final List<String> imageUrls = await _uploadPostImage(input);
    final TradeItem fallback = TradeItem(
      id: _generateUniqueId(),
      title: input.title,
      description: input.description,
      wantedItem: input.wantedItem,
      category: input.category,
      tradeMethod: input.tradeMethod,
      status: ItemTradeStatus.available,
      ownerId: input.ownerId,
      ownerName: input.ownerName,
      ownerGeneration: input.ownerGeneration,
      createdAt: DateTime.now(),
      imageBytes: input.imageBytes,
      imageUrl: imageUrls.firstOrNull,
    );
    final ApiResponse<TradeItem> response = await _postApi.create(
      TradeItemMapper.createBody(input, imageUrls),
      (json) => _mapTradeItem(json, fallback: fallback),
    );
    final TradeItem item = response.data;
    _upsertItem(item);
    return item;
  }

  @override
  Future<void> updateItemStatus(String itemId, ItemTradeStatus status) async {
    final TradeItem? current = _itemById(itemId);
    final Map<String, Object?> body = current == null
        ? {'status': TradeItemMapper.statusToApi(status)}
        : TradeItemMapper.updateBody(current.copyWith(status: status));
    final ApiResponse<TradeItem> response = await _postApi.update(
      itemId,
      body,
      (json) => _mapTradeItem(json, fallback: current),
    );
    final Map<String, dynamic>? data = ApiResponse.dataMap(response.raw);

    if (data != null && data.isNotEmpty) {
      _upsertItem(response.data);
    } else if (current != null) {
      _upsertItem(current.copyWith(status: status));
    }
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await _postApi.delete(itemId);
    _items.removeWhere((item) => item.id == itemId);
    _comments.removeWhere((comment) => comment.itemId == itemId);
    for (final List<String> ids in _recentItemIds.values) {
      ids.remove(itemId);
    }
  }

  @override
  Future<void> setItemLiked({
    required String itemId,
    required String userId,
    required String userName,
    required bool isLiked,
  }) async {
    await _likeApi.setLiked(itemId: itemId, isLiked: isLiked);

    final TradeItem? item = _itemById(itemId);
    if (item == null) return;
    final Set<String> likedUserIds = {...item.likedUserIds};
    isLiked ? likedUserIds.add(userId) : likedUserIds.remove(userId);
    _upsertItem(item.copyWith(likedUserIds: likedUserIds));
  }

  @override
  Future<void> recordItemView({
    required String itemId,
    required String userId,
  }) async {
    final List<String> ids = _recentItemIds.putIfAbsent(userId, () => []);
    ids
      ..remove(itemId)
      ..insert(0, itemId);
    if (ids.length > 20) ids.removeRange(20, ids.length);
  }

  @override
  Future<ItemComment> createComment({
    required String itemId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentCommentId,
  }) async {
    final ItemComment fallback = ItemComment(
      id: _generateUniqueId(),
      itemId: itemId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: DateTime.now(),
      parentCommentId: parentCommentId,
    );
    final ApiResponse<ItemComment> response = parentCommentId == null
        ? await _commentApi.create(
            itemId: itemId,
            content: content,
            mapper: (json) => _mapComment(json, fallback: fallback),
          )
        : await _commentApi.createReply(
            parentCommentId: parentCommentId,
            content: content,
            mapper: (json) => _mapComment(json, fallback: fallback),
          );
    final ItemComment comment = response.data;
    _upsertComment(comment);
    return comment;
  }

  Future<List<ItemComment>> fetchCommentThread(String commentId) async {
    final List<String> listKeys = const ['content', 'comments', 'replies'];
    final ApiResponse<List<ItemComment>> response = await _commentApi
        .fetchThread(commentId, (json) => _mapComment(json));
    final List<ItemComment> comments = response.data;

    if (comments.isEmpty) {
      final Map<String, dynamic>? data = ApiResponse.dataMap(response.raw);
      if (data != null &&
          data.isNotEmpty &&
          !ApiResponse.hasList(data, listKeys)) {
        final ItemComment comment = _mapComment(data);
        _upsertComment(comment);
        return [comment];
      }
    }

    for (final ItemComment comment in comments) {
      _upsertComment(comment);
    }
    return List.unmodifiable(comments);
  }

  @override
  Future<void> updateComment({
    required String commentId,
    required String authorId,
    required String content,
  }) async {
    final ItemComment? current = _commentById(commentId);
    final ApiResponse<ItemComment> response = await _commentApi.update(
      commentId: commentId,
      content: content,
      mapper: (json) => _mapComment(json, fallback: current),
    );
    final Map<String, dynamic>? data = ApiResponse.dataMap(response.raw);

    if (data != null && data.isNotEmpty) {
      _upsertComment(response.data);
    } else if (current != null) {
      _upsertComment(current.copyWith(content: content));
    }
  }

  @override
  Future<void> deleteComment({
    required String commentId,
    required String authorId,
  }) async {
    await _commentApi.delete(commentId);
    _comments.removeWhere(
      (comment) =>
          comment.id == commentId || comment.parentCommentId == commentId,
    );
  }

  Future<List<Notice>> fetchNotices() async {
    final ApiResponse<List<Notice>> response = await _noticeApi.fetchAll(
      (json) => _mapNotice(json),
    );
    final List<Notice> notices = response.data;

    _notices
      ..clear()
      ..addAll(notices);
    return List.unmodifiable(notices);
  }

  Future<Notice> fetchNotice(String noticeId) async {
    final ApiResponse<Notice> response = await _noticeApi.fetchOne(
      noticeId,
      (json) => _mapNotice(json),
    );
    final Notice notice = response.data;
    _upsertNotice(notice);
    return notice;
  }

  @override
  Future<Notice> createNotice({
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  }) async {
    final Notice fallback = Notice(
      id: _generateUniqueId(),
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
    );
    final ApiResponse<Notice> response = await _noticeApi.create(
      title: title,
      content: content,
      mapper: (json) => _mapNotice(json, fallback: fallback),
    );
    final Notice notice = response.data;
    _upsertNotice(notice);
    return notice;
  }

  @override
  Future<void> updateNotice({
    required String noticeId,
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  }) async {
    final Notice? current = _noticeById(noticeId);
    final ApiResponse<Notice> response = await _noticeApi.update(
      noticeId: noticeId,
      title: title,
      content: content,
      mapper: (json) => _mapNotice(json, fallback: current),
    );
    final Map<String, dynamic>? data = ApiResponse.dataMap(response.raw);

    if (data != null && data.isNotEmpty) {
      _upsertNotice(response.data);
    } else if (current != null) {
      _upsertNotice(
        current.copyWith(
          title: title,
          content: content,
          author: author,
          createdAt: createdAt,
        ),
      );
    }
  }

  @override
  Future<void> deleteNotice(String noticeId) async {
    await _noticeApi.delete(noticeId);
    _notices.removeWhere((notice) => notice.id == noticeId);
  }

  @override
  Future<TradeRequest> createTradeRequest({
    required String itemId,
    required String requesterId,
    required String requesterName,
  }) {
    throw UnsupportedError('거래 요청 API 명세가 아직 연결되지 않았습니다.');
  }

  @override
  Future<void> updateTradeRequestStatus({
    required String requestId,
    required TradeRequestStatus status,
  }) {
    throw UnsupportedError('거래 요청 상태 변경 API 명세가 아직 연결되지 않았습니다.');
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {}

  @override
  Future<void> updateOwnerProfile({
    required String ownerId,
    required String ownerName,
    required String ownerGeneration,
  }) async {
    for (int index = 0; index < _items.length; index++) {
      final TradeItem item = _items[index];
      if (item.ownerId == ownerId) {
        _items[index] = item.copyWith(
          ownerName: ownerName,
          ownerGeneration: ownerGeneration,
        );
      }
    }

    for (int index = 0; index < _comments.length; index++) {
      final ItemComment comment = _comments[index];
      if (comment.authorId == ownerId) {
        _comments[index] = ItemComment(
          id: comment.id,
          itemId: comment.itemId,
          authorId: comment.authorId,
          authorName: ownerName,
          content: comment.content,
          createdAt: comment.createdAt,
          parentCommentId: comment.parentCommentId,
        );
      }
    }
  }

  Future<List<String>> _uploadPostImage(CreateTradeItemInput input) {
    final String filename =
        _fileNameFromPath(input.imagePath) ??
        'item-${DateTime.now().millisecondsSinceEpoch}.jpg';
    return _postApi.uploadImages(
      filename: filename,
      contentType: _contentTypeFor(filename),
      bytes: input.imageBytes,
    );
  }

  void _syncCommentsFromPosts(dynamic response) {
    for (final Map<String, dynamic> post in ApiResponse.dataList(response)) {
      final String itemId =
          (post['id'] ?? post['productId'] ?? post['product_id'])?.toString() ??
          '';
      for (final String key in const ['comments', 'commentList', 'replies']) {
        final List<Map<String, dynamic>> maps = ApiResponse.mapList(post[key]);
        if (maps.isEmpty) continue;
        for (final Map<String, dynamic> map in maps) {
          _upsertComment(
            _mapComment(
              map,
              fallback: ItemComment(
                id: _generateUniqueId(),
                itemId: itemId,
                authorId: '',
                authorName: '',
                content: '',
                createdAt: DateTime.now(),
              ),
            ),
          );
        }
        break;
      }
    }
  }

  TradeItem _mapTradeItem(Map<String, dynamic> json, {TradeItem? fallback}) {
    return TradeItemMapper.fromJson(
      json,
      fallback: fallback,
      currentUserId: currentUserIdProvider?.call(),
      fallbackId: _generateUniqueId,
    );
  }

  ItemComment _mapComment(Map<String, dynamic> json, {ItemComment? fallback}) {
    return ItemCommentMapper.fromJson(
      json,
      fallback: fallback,
      fallbackId: _generateUniqueId,
    );
  }

  Notice _mapNotice(Map<String, dynamic> json, {Notice? fallback}) {
    return NoticeMapper.fromJson(
      json,
      fallback: fallback,
      fallbackId: _generateUniqueId,
    );
  }

  String _generateUniqueId() {
    return '${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';
  }

  void _upsertItem(TradeItem item) {
    final int index = _items.indexWhere((entry) => entry.id == item.id);
    index == -1 ? _items.insert(0, item) : _items[index] = item;
  }

  void _upsertComment(ItemComment comment) {
    final int index = _comments.indexWhere((entry) => entry.id == comment.id);
    index == -1 ? _comments.add(comment) : _comments[index] = comment;
  }

  void _upsertNotice(Notice notice) {
    final int index = _notices.indexWhere((entry) => entry.id == notice.id);
    index == -1 ? _notices.insert(0, notice) : _notices[index] = notice;
  }

  TradeItem? _itemById(String itemId) {
    return _items.where((item) => item.id == itemId).firstOrNull;
  }

  ItemComment? _commentById(String commentId) {
    return _comments.where((comment) => comment.id == commentId).firstOrNull;
  }

  Notice? _noticeById(String noticeId) {
    return _notices.where((notice) => notice.id == noticeId).firstOrNull;
  }

  static String? _fileNameFromPath(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    final String filename = path.replaceAll('\\', '/').split('/').last;
    return filename.contains('.') ? filename : null;
  }

  static String _contentTypeFor(String filename) {
    return switch (filename.split('.').last.toLowerCase()) {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      'heif' => 'image/heif',
      _ => 'image/jpeg',
    };
  }
}
