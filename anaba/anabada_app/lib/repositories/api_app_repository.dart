import '../models/app_notification.dart';
import '../models/item_comment.dart';
import '../models/notice.dart';
import '../models/trade_item.dart';
import '../models/trade_request.dart';
import '../services/api_client.dart';
import 'app_repository.dart';

typedef CurrentUserIdProvider = String? Function();

class ApiAppRepository implements AppRepository {
  ApiAppRepository(this._apiClient, {this.currentUserIdProvider});

  final ApiClient _apiClient;
  final CurrentUserIdProvider? currentUserIdProvider;

  final List<TradeItem> _items = [];
  final List<ItemComment> _comments = [];
  final List<Notice> _notices = [];
  final Map<String, List<String>> _recentItemIds = {};
  int _idCounter = 0;

  String _generateUniqueId() {
    return '${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';
  }

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
  List<String> recentItemIdsFor(String userId) =>
      List.unmodifiable(_recentItemIds[userId] ?? const []);

  @override
  Future<void> refresh() async {
    await fetchPosts();
    await fetchNotices();
  }

  Future<List<TradeItem>> fetchPosts() async {
    final dynamic response = await _apiClient.get(
      '/api/post',
      authenticated: false,
    );
    final List<TradeItem> items = _mapsFromResponse(response)
        .map(_tradeItemFromJson)
        .toList(growable: false);

    _items
      ..clear()
      ..addAll(items);
    _syncCommentsFromPostResponse(response);

    return List.unmodifiable(items);
  }

  Future<TradeItem> fetchPost(String productId) async {
    final dynamic response = await _apiClient.get(
      '/api/post/$productId',
      authenticated: false,
    );
    final TradeItem item = _tradeItemFromJson(_dataMap(response) ?? {});
    _upsertItem(item);
    _syncCommentsFromPostResponse(response);
    return item;
  }

  Future<List<TradeItem>> fetchRecentPosts() async {
    final dynamic response = await _apiClient.get('/api/post/recent');
    final List<TradeItem> items = _mapsFromResponse(response)
        .map(_tradeItemFromJson)
        .toList(growable: false);

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
    final List<String> imageUrls = await _uploadPostImages(input);
    final dynamic response = await _apiClient.post(
      '/api/post',
      body: _createPostBody(input, imageUrls),
    );

    final TradeItem item = _tradeItemFromJson(
      _dataMap(response) ?? {},
      fallback: TradeItem(
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
        imageUrl: imageUrls.isEmpty ? null : imageUrls.first,
      ),
    );
    _upsertItem(item);

    return item;
  }

  @override
  Future<void> updateItemStatus(
    String itemId,
    ItemTradeStatus status,
  ) async {
    final TradeItem? current = _itemById(itemId);
    final dynamic response = await _apiClient.put(
      '/api/post/$itemId',
      body: current == null
          ? {'status': _statusToApi(status)}
          : _updatePostBody(current.copyWith(status: status)),
    );

    final Map<String, dynamic>? data = _dataMap(response);
    if (data != null && data.isNotEmpty) {
      _upsertItem(_tradeItemFromJson(data, fallback: current));
    } else if (current != null) {
      _upsertItem(current.copyWith(status: status));
    }
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await _apiClient.delete('/api/post/$itemId');

    _items.removeWhere((item) => item.id == itemId);
    _comments.removeWhere((comment) => comment.itemId == itemId);
    for (final List<String> recentIds in _recentItemIds.values) {
      recentIds.remove(itemId);
    }
  }

  @override
  Future<void> setItemLiked({
    required String itemId,
    required String userId,
    required String userName,
    required bool isLiked,
  }) async {
    if (isLiked) {
      await _apiClient.post('/api/like/$itemId');
    } else {
      await _apiClient.delete('/api/like/$itemId');
    }

    final TradeItem? item = _itemById(itemId);
    if (item == null) return;

    final Set<String> likedUserIds = {...item.likedUserIds};
    if (isLiked) {
      likedUserIds.add(userId);
    } else {
      likedUserIds.remove(userId);
    }
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

    if (ids.length > 20) {
      ids.removeRange(20, ids.length);
    }
  }

  @override
  Future<ItemComment> createComment({
    required String itemId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentCommentId,
  }) async {
    final bool isReply = parentCommentId != null;
    final dynamic response = await _apiClient.post(
      isReply ? '/api/comment/$parentCommentId' : '/api/comment',
      body: isReply
          ? {'content': content}
          : {'productId': _apiId(itemId), 'content': content},
    );

    final ItemComment comment = _commentFromJson(
      _dataMap(response) ?? {},
      fallback: ItemComment(
        id: _generateUniqueId(),
        itemId: itemId,
        authorId: authorId,
        authorName: authorName,
        content: content,
        createdAt: DateTime.now(),
        parentCommentId: parentCommentId,
      ),
    );
    _upsertComment(comment);

    return comment;
  }

  Future<List<ItemComment>> fetchCommentThread(String commentId) async {
    final dynamic response = await _apiClient.get('/api/comment/$commentId');
    final List<ItemComment> comments = _mapsFromResponse(
      response,
      listKeys: const ['content', 'comments', 'replies'],
    ).map(_commentFromJson).toList(growable: false);

    if (comments.isEmpty) {
      final Map<String, dynamic>? data = _dataMap(response);
      if (data != null &&
          data.isNotEmpty &&
          !_hasListValue(data, const ['content', 'comments', 'replies'])) {
        final ItemComment comment = _commentFromJson(data);
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
    final dynamic response = await _apiClient.patch(
      '/api/comment/$commentId',
      body: {'content': content},
    );

    final Map<String, dynamic>? data = _dataMap(response);
    if (data != null && data.isNotEmpty) {
      _upsertComment(_commentFromJson(data, fallback: current));
    } else if (current != null) {
      _upsertComment(current.copyWith(content: content));
    }
  }

  @override
  Future<void> deleteComment({
    required String commentId,
    required String authorId,
  }) async {
    await _apiClient.delete('/api/comment/$commentId');
    _comments.removeWhere(
      (comment) => comment.id == commentId || comment.parentCommentId == commentId,
    );
  }

  Future<List<Notice>> fetchNotices() async {
    final dynamic response = await _apiClient.get(
      '/api/notice',
      authenticated: false,
    );
    final List<Notice> notices = _mapsFromResponse(
      response,
      listKeys: const ['content', 'notices'],
    ).map(_noticeFromJson).toList(growable: false);

    _notices
      ..clear()
      ..addAll(notices);

    return List.unmodifiable(notices);
  }

  Future<Notice> fetchNotice(String noticeId) async {
    final dynamic response = await _apiClient.get(
      '/api/notice/$noticeId',
      authenticated: false,
    );
    final Notice notice = _noticeFromJson(_dataMap(response) ?? {});
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
    final dynamic response = await _apiClient.post(
      '/api/notice',
      body: {'title': title, 'content': content},
    );

    final Notice notice = _noticeFromJson(
      _dataMap(response) ?? {},
      fallback: Notice(
        id: _generateUniqueId(),
        title: title,
        content: content,
        author: author,
        createdAt: createdAt,
      ),
    );
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
    final dynamic response = await _apiClient.patch(
      '/api/notice/$noticeId',
      body: {'title': title, 'content': content},
    );

    final Map<String, dynamic>? data = _dataMap(response);
    if (data != null && data.isNotEmpty) {
      _upsertNotice(_noticeFromJson(data, fallback: current));
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
    await _apiClient.delete('/api/notice/$noticeId');
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

  Future<List<String>> _uploadPostImages(CreateTradeItemInput input) async {
    final String filename = _fileNameFromPath(input.imagePath) ??
        'item-${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String contentType = _contentTypeFor(filename);

    final dynamic response = await _apiClient.post(
      '/api/post/presigned-urls',
      body: {
        'filenames': [filename],
        'contentTypes': [contentType],
      },
    );
    final List<Map<String, dynamic>> entries = _mapList(_dataOf(response));

    if (entries.isEmpty) return const [];

    final String? uploadUrl = _stringValue(entries.first['uploadUrl']);
    final String? imageUrl = _stringValue(entries.first['imageUrl']);

    if (uploadUrl != null && uploadUrl.isNotEmpty) {
      await _apiClient.putBytes(
        Uri.parse(uploadUrl),
        bytes: input.imageBytes,
        contentType: contentType,
      );
    }

    return imageUrl == null || imageUrl.isEmpty ? const [] : [imageUrl];
  }

  Map<String, Object?> _createPostBody(
    CreateTradeItemInput input,
    List<String> imageUrls,
  ) {
    return {
      'title': input.title,
      'content': input.description,
      'price': 0,
      'hopeItem': input.wantedItem,
      'tradeType': _tradeTypeToApi(input.tradeMethod),
      'category': _categoryToApi(input.category),
      'imageUrls': imageUrls,
    };
  }

  Map<String, Object?> _updatePostBody(TradeItem item) {
    return {
      'title': item.title,
      'content': item.description,
      'price': 0,
      'hopeItem': item.wantedItem,
      'tradeType': _tradeTypeToApi(item.tradeMethod),
      'category': _categoryToApi(item.category),
      'status': _statusToApi(item.status),
      'imageUrls': item.imageUrl == null ? const [] : [item.imageUrl],
    };
  }

  void _syncCommentsFromPostResponse(dynamic response) {
    final List<Map<String, dynamic>> postMaps = _mapsFromResponse(response);
    for (final Map<String, dynamic> postMap in postMaps) {
      final String? itemId = _stringValue(
        postMap['id'] ?? postMap['productId'] ?? postMap['product_id'],
      );
      final List<Map<String, dynamic>> commentMaps = _commentMapsFromPost(postMap);
      for (final Map<String, dynamic> commentMap in commentMaps) {
        _upsertComment(
          _commentFromJson(
            commentMap,
            fallback: itemId == null
                ? null
                : ItemComment(
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
    }
  }

  List<Map<String, dynamic>> _commentMapsFromPost(Map<String, dynamic> json) {
    for (final String key in const ['comments', 'commentList', 'replies']) {
      final List<Map<String, dynamic>> maps = _mapList(json[key]);
      if (maps.isNotEmpty) return maps;
    }
    return const [];
  }

  TradeItem _tradeItemFromJson(
    Map<String, dynamic> json, {
    TradeItem? fallback,
  }) {
    final List<String> imageUrls = _stringList(
      json['imageUrls'] ?? json['images'] ?? json['imageUrl'],
    );
    final String? currentUserId = currentUserIdProvider?.call();
    final Set<String> likedUserIds = {...?fallback?.likedUserIds};
    final bool? isLiked = _boolValue(json['isLiked'] ?? json['liked']);
    final int? likeCount = _intValue(json['likeCount'] ?? json['likes']);

    if (isLiked == true && currentUserId != null && currentUserId.isNotEmpty) {
      likedUserIds.add(currentUserId);
    }
    if (likeCount != null) {
      if (likeCount > likedUserIds.length) {
        for (int index = likedUserIds.length; index < likeCount; index++) {
          likedUserIds.add('like-user-$index');
        }
      } else if (likeCount < likedUserIds.length) {
        int removeCount = likedUserIds.length - likeCount;
        final List<String> dummyIds = likedUserIds
            .where((id) => id.startsWith('like-user-'))
            .toList(growable: false);

        for (final String dummyId in dummyIds) {
          if (removeCount <= 0) break;
          likedUserIds.remove(dummyId);
          removeCount--;
        }
      }
    }

    return TradeItem(
      id: _stringValue(json['id'] ?? json['productId'] ?? json['product_id']) ??
          fallback?.id ??
          _generateUniqueId(),
      title: _stringValue(json['title'] ?? json['name']) ??
          fallback?.title ??
          '',
      description: _stringValue(json['content'] ?? json['description']) ??
          fallback?.description ??
          '',
      wantedItem: _stringValue(json['hopeItem'] ?? json['wantedItem']) ??
          fallback?.wantedItem ??
          '',
      category:
          _categoryFromApi(json['category']) ?? fallback?.category ?? ItemCategory.etc,
      tradeMethod: _tradeMethodFromApi(json['tradeType'] ?? json['tradeMethod']) ??
          fallback?.tradeMethod ??
          TradeMethod.exchange,
      status: _statusFromApi(json['status']) ??
          fallback?.status ??
          ItemTradeStatus.available,
      ownerId: _stringValue(json['userId'] ?? json['ownerId'] ?? json['writerId']) ??
          fallback?.ownerId ??
          '',
      ownerName: _stringValue(json['userName'] ?? json['ownerName'] ?? json['writer']) ??
          fallback?.ownerName ??
          '',
      ownerGeneration:
          _stringValue(json['generation'] ?? json['userGeneration']) ??
          fallback?.ownerGeneration ??
          '',
      createdAt: _dateValue(json['createdAt'] ?? json['created_at']) ??
          fallback?.createdAt ??
          DateTime.now(),
      imageUrl: imageUrls.isEmpty ? fallback?.imageUrl : imageUrls.first,
      likedUserIds: likedUserIds,
    );
  }

  ItemComment _commentFromJson(
    Map<String, dynamic> json, {
    ItemComment? fallback,
  }) {
    return ItemComment(
      id: _stringValue(json['id'] ?? json['commentId'] ?? json['comment_id']) ??
          fallback?.id ??
          _generateUniqueId(),
      itemId:
          _stringValue(json['productId'] ?? json['postId'] ?? json['itemId']) ??
          fallback?.itemId ??
          '',
      authorId: _stringValue(json['userId'] ?? json['authorId'] ?? json['writerId']) ??
          fallback?.authorId ??
          '',
      authorName:
          _stringValue(json['userName'] ?? json['authorName'] ?? json['writer']) ??
          fallback?.authorName ??
          '',
      content: _stringValue(json['content']) ?? fallback?.content ?? '',
      createdAt: _dateValue(json['createdAt'] ?? json['created_at']) ??
          fallback?.createdAt ??
          DateTime.now(),
      parentCommentId:
          _stringValue(json['parentCommentId'] ?? json['parentId']) ??
          fallback?.parentCommentId,
    );
  }

  Notice _noticeFromJson(Map<String, dynamic> json, {Notice? fallback}) {
    return Notice(
      id: _stringValue(json['id'] ?? json['noticeId'] ?? json['notice_id']) ??
          fallback?.id ??
          _generateUniqueId(),
      title: _stringValue(json['title']) ?? fallback?.title ?? '',
      content: _stringValue(json['content']) ?? fallback?.content ?? '',
      author: _stringValue(json['author'] ?? json['writer'] ?? json['userName']) ??
          fallback?.author ??
          '관리자',
      createdAt: _dateValue(json['createdAt'] ?? json['created_at']) ??
          fallback?.createdAt ??
          DateTime.now(),
    );
  }

  void _upsertItem(TradeItem item) {
    final int index = _items.indexWhere((entry) => entry.id == item.id);
    if (index == -1) {
      _items.insert(0, item);
    } else {
      _items[index] = item;
    }
  }

  void _upsertComment(ItemComment comment) {
    final int index = _comments.indexWhere((entry) => entry.id == comment.id);
    if (index == -1) {
      _comments.add(comment);
    } else {
      _comments[index] = comment;
    }
  }

  void _upsertNotice(Notice notice) {
    final int index = _notices.indexWhere((entry) => entry.id == notice.id);
    if (index == -1) {
      _notices.insert(0, notice);
    } else {
      _notices[index] = notice;
    }
  }

  TradeItem? _itemById(String itemId) {
    for (final TradeItem item in _items) {
      if (item.id == itemId) return item;
    }
    return null;
  }

  ItemComment? _commentById(String commentId) {
    for (final ItemComment comment in _comments) {
      if (comment.id == commentId) return comment;
    }
    return null;
  }

  Notice? _noticeById(String noticeId) {
    for (final Notice notice in _notices) {
      if (notice.id == noticeId) return notice;
    }
    return null;
  }

  static Object _apiId(String id) => int.tryParse(id) ?? id;

  static dynamic _dataOf(dynamic response) {
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'];
    }
    return response;
  }

  static Map<String, dynamic>? _dataMap(dynamic response) {
    final dynamic data = _dataOf(response);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  static List<Map<String, dynamic>> _mapsFromResponse(
    dynamic response, {
    List<String> listKeys = const ['content', 'items', 'posts'],
  }) {
    final dynamic data = _dataOf(response);
    if (data is List) return _mapList(data);

    final Map<String, dynamic>? dataMap = _dataMap(response);
    if (dataMap == null) return const [];

    for (final String key in listKeys) {
      final dynamic value = dataMap[key];
      if (value is List) {
        return _mapList(value);
      }
    }

    return dataMap.isEmpty ? const [] : [dataMap];
  }

  static bool _hasListValue(
    Map<String, dynamic> map,
    List<String> keys,
  ) {
    for (final String key in keys) {
      if (map[key] is List) return true;
    }
    return false;
  }

  static List<Map<String, dynamic>> _mapList(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList(growable: false);
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value
          .map(_stringValue)
          .whereType<String>()
          .where((entry) => entry.isNotEmpty)
          .toList(growable: false);
    }

    final String? singleValue = _stringValue(value);
    return singleValue == null || singleValue.isEmpty
        ? const []
        : [singleValue];
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static int? _intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool? _boolValue(dynamic value) {
    if (value is bool) return value;
    if (value is String) return bool.tryParse(value.toLowerCase());
    return null;
  }

  static DateTime? _dateValue(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static String _categoryToApi(ItemCategory category) {
    return switch (category) {
      ItemCategory.food => 'FOOD',
      ItemCategory.clothes => 'CLOTHES',
      ItemCategory.book => 'BOOK',
      ItemCategory.etc => 'ETC',
    };
  }

  static ItemCategory? _categoryFromApi(dynamic value) {
    final String? category = _stringValue(value)?.toUpperCase();
    return switch (category) {
      'FOOD' || '식품' => ItemCategory.food,
      'CLOTHES' || 'CLOTHING' || '의류' => ItemCategory.clothes,
      'BOOK' || 'BOOKS' || '도서' => ItemCategory.book,
      'ETC' || 'OTHER' || '기타' => ItemCategory.etc,
      _ => null,
    };
  }

  static String _tradeTypeToApi(TradeMethod tradeMethod) {
    return switch (tradeMethod) {
      TradeMethod.exchange => 'EXCHANGE',
      TradeMethod.share => 'SHARE',
    };
  }

  static TradeMethod? _tradeMethodFromApi(dynamic value) {
    final String? tradeType = _stringValue(value)?.toUpperCase();
    return switch (tradeType) {
      'SHARE' || '나눔' => TradeMethod.share,
      'EXCHANGE' || 'TRADE' || '교환' => TradeMethod.exchange,
      _ => null,
    };
  }

  static String _statusToApi(ItemTradeStatus status) {
    return switch (status) {
      ItemTradeStatus.available => 'ACTIVE',
      ItemTradeStatus.completed => 'COMPLETED',
    };
  }

  static ItemTradeStatus? _statusFromApi(dynamic value) {
    final String status = _stringValue(value)?.toUpperCase() ?? '';
    if (status.contains('ACTIVE') || status.contains('AVAILABLE')) {
      return ItemTradeStatus.available;
    }
    if (status.contains('COMPLETE') ||
        status.contains('DONE') ||
        status.contains('FINISH')) {
      return ItemTradeStatus.completed;
    }
    return null;
  }

  static String? _fileNameFromPath(String? path) {
    if (path == null || path.trim().isEmpty) return null;

    final String normalizedPath = path.replaceAll('\\', '/');
    final String fileName = normalizedPath.split('/').last;
    return fileName.contains('.') ? fileName : null;
  }

  static String _contentTypeFor(String filename) {
    final String extension = filename.split('.').last.toLowerCase();
    return switch (extension) {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      'heif' => 'image/heif',
      _ => 'image/jpeg',
    };
  }
}
