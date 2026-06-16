import '../models/app_notification.dart';
import '../models/item_comment.dart';
import '../models/notice.dart';
import '../models/trade_item.dart';
import '../models/trade_request.dart';
import 'app_repository.dart';

class LocalAppRepository implements AppRepository {
  LocalAppRepository() {
    final DateTime now = DateTime.now();

    _items.addAll([
      TradeItem(
        id: 'item-1',
        title: '깨끗한 텀블러',
        description: '사용 횟수가 적어 상태가 좋습니다.',
        wantedItem: '필기구',
        category: ItemCategory.etc,
        tradeMethod: TradeMethod.exchange,
        status: ItemTradeStatus.available,
        ownerId: 'user-2',
        ownerName: '김준수',
        ownerGeneration: '9기',
        createdAt: now.subtract(const Duration(minutes: 3)),
        likedUserIds: const {'fake-user-1', 'user-3'},
      ),
      TradeItem(
        id: 'item-2',
        title: '프로그래밍 입문서',
        description: '필기 없이 깨끗하게 사용했습니다.',
        wantedItem: '소설책',
        category: ItemCategory.book,
        tradeMethod: TradeMethod.exchange,
        status: ItemTradeStatus.available,
        ownerId: 'fake-user-1',
        ownerName: '테스트 사용자',
        ownerGeneration: '10기',
        createdAt: now.subtract(const Duration(hours: 2)),
        likedUserIds: const {'user-2', 'user-3', 'user-4'},
      ),
      TradeItem(
        id: 'item-3',
        title: '후드 집업',
        description: '사이즈가 맞지 않아 나눔합니다.',
        category: ItemCategory.clothes,
        tradeMethod: TradeMethod.share,
        status: ItemTradeStatus.available,
        ownerId: 'user-3',
        ownerName: '안율',
        ownerGeneration: '10기',
        createdAt: now.subtract(const Duration(hours: 5)),
        likedUserIds: const {'fake-user-1'},
      ),
      TradeItem(
        id: 'item-4',
        title: '간식 꾸러미',
        description: '유통기한이 넉넉한 미개봉 간식입니다.',
        category: ItemCategory.food,
        tradeMethod: TradeMethod.share,
        status: ItemTradeStatus.completed,
        ownerId: 'user-4',
        ownerName: '추혜인',
        ownerGeneration: '10기',
        createdAt: now.subtract(const Duration(days: 1)),
        likedUserIds: const {'user-2', 'user-3', 'user-5', 'fake-user-1'},
      ),
      TradeItem(
        id: 'item-5',
        title: '무선 마우스',
        description: '정상 작동하며 건전지도 함께 드립니다.',
        wantedItem: 'USB 허브',
        category: ItemCategory.etc,
        tradeMethod: TradeMethod.exchange,
        status: ItemTradeStatus.completed,
        ownerId: 'fake-user-1',
        ownerName: '테스트 사용자',
        ownerGeneration: '10기',
        createdAt: now.subtract(const Duration(days: 2)),
        likedUserIds: const {'user-2', 'user-3'},
      ),
    ]);

    _comments.addAll([
      ItemComment(
        id: 'comment-1',
        itemId: 'item-1',
        authorId: 'user-3',
        authorName: '안율',
        content: '아직 교환 가능한가요?',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      ItemComment(
        id: 'comment-2',
        itemId: 'item-1',
        authorId: 'fake-user-1',
        authorName: '테스트 사용자',
        content: '어디에서 거래할 수 있나요?',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      ItemComment(
        id: 'comment-3',
        itemId: 'item-2',
        authorId: 'user-2',
        authorName: '김준수',
        content: '책 상태가 궁금합니다.',
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
    ]);

    _notices.addAll([
      Notice(
        id: 'notice-1',
        title: '서비스 점검 안내',
        content: '''안녕하세요, 아나바다 운영팀입니다.

보다 안정적인 서비스 제공을 위해 시스템 점검을 진행할 예정입니다.

점검 시간 동안 서비스 이용이 일시적으로 제한될 수 있습니다.
이용에 불편을 드려 죄송합니다.''',
        author: '관리자',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      Notice(
        id: 'notice-2',
        title: '안전한 거래를 위한 안내',
        content: '교환 장소는 사람이 많은 공공장소를 이용해 주세요.',
        author: '관리자',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Notice(
        id: 'notice-3',
        title: '아나바다 이용 규칙',
        content: '서로를 배려하는 표현과 정확한 물건 정보를 사용해 주세요.',
        author: '관리자',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ]);

    _notifications.addAll([
      AppNotification(
        id: 'notification-1',
        userId: 'fake-user-1',
        type: AppNotificationType.favorite,
        title: '찜 알림',
        content: '프로그래밍 입문서를 찜했어요.',
        createdAt: now.subtract(const Duration(minutes: 3)),
        relatedItemId: 'item-2',
      ),
      AppNotification(
        id: 'notification-2',
        userId: 'fake-user-1',
        type: AppNotificationType.request,
        title: '교환 요청',
        content: '프로그래밍 입문서에 대한 교환 요청이 도착했어요.',
        createdAt: now.subtract(const Duration(minutes: 15)),
        relatedItemId: 'item-2',
        relatedRequestId: 'request-1',
      ),
      AppNotification(
        id: 'notification-3',
        userId: 'fake-user-1',
        type: AppNotificationType.comment,
        title: '새 댓글',
        content: '프로그래밍 입문서에 새로운 댓글이 달렸어요.',
        createdAt: now.subtract(const Duration(minutes: 30)),
        relatedItemId: 'item-2',
      ),
      AppNotification(
        id: 'notification-4',
        userId: 'fake-user-1',
        type: AppNotificationType.notice,
        title: '공지사항',
        content: '서비스 점검 안내',
        createdAt: now.subtract(const Duration(hours: 3)),
        relatedNoticeId: 'notice-1',
      ),
    ]);

    _requests.add(
      TradeRequest(
        id: 'request-1',
        itemId: 'item-2',
        requesterId: 'user-2',
        requesterName: '김준수',
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
    );

    _recentItemIds['fake-user-1'] = ['item-1', 'item-3'];
  }

  final List<TradeItem> _items = [];
  final List<ItemComment> _comments = [];
  final List<AppNotification> _notifications = [];
  final List<Notice> _notices = [];
  final List<TradeRequest> _requests = [];
  final Map<String, List<String>> _recentItemIds = {};

  @override
  List<TradeItem> get cachedItems => List.unmodifiable(_items);

  @override
  List<ItemComment> get cachedComments => List.unmodifiable(_comments);

  @override
  List<AppNotification> get cachedNotifications =>
      List.unmodifiable(_notifications);

  @override
  List<Notice> get cachedNotices => List.unmodifiable(_notices);

  @override
  List<TradeRequest> get cachedRequests => List.unmodifiable(_requests);

  @override
  List<String> recentItemIdsFor(String userId) =>
      List.unmodifiable(_recentItemIds[userId] ?? const []);

  @override
  Future<void> refresh() async {}

  @override
  Future<TradeItem> createItem(CreateTradeItemInput input) async {
    final TradeItem item = TradeItem(
      id: 'item-${DateTime.now().microsecondsSinceEpoch}',
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
    );

    _items.insert(0, item);
    return item;
  }

  @override
  Future<void> updateItemStatus(
    String itemId,
    ItemTradeStatus status,
  ) async {
    final int index = _itemIndex(itemId);
    _items[index] = _items[index].copyWith(status: status);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    _items.removeWhere((item) => item.id == itemId);
    _comments.removeWhere((comment) => comment.itemId == itemId);
    _requests.removeWhere((request) => request.itemId == itemId);
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
    final int index = _itemIndex(itemId);
    final TradeItem item = _items[index];
    final Set<String> likedUserIds = {...item.likedUserIds};

    if (isLiked) {
      likedUserIds.add(userId);
    } else {
      likedUserIds.remove(userId);
    }

    _items[index] = item.copyWith(likedUserIds: likedUserIds);

    if (isLiked && item.ownerId != userId) {
      _notifications.insert(
        0,
        AppNotification(
          id: _newId('notification'),
          userId: item.ownerId,
          type: AppNotificationType.favorite,
          title: '찜 알림',
          content: '$userName님이 ${item.title}을 찜했어요.',
          createdAt: DateTime.now(),
          relatedItemId: item.id,
        ),
      );
    }
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
    final TradeItem item = _item(itemId);
    final ItemComment comment = ItemComment(
      id: _newId('comment'),
      itemId: itemId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: DateTime.now(),
      parentCommentId: parentCommentId,
    );

    _comments.add(comment);

    if (item.ownerId != authorId) {
      _notifications.insert(
        0,
        AppNotification(
          id: _newId('notification'),
          userId: item.ownerId,
          type: AppNotificationType.comment,
          title: '새 댓글',
          content: '${item.title}에 새로운 댓글이 달렸어요.',
          createdAt: DateTime.now(),
          relatedItemId: item.id,
        ),
      );
    }

    return comment;
  }

  @override
  Future<void> updateComment({
    required String commentId,
    required String authorId,
    required String content,
  }) async {
    final int index = _comments.indexWhere(
      (comment) => comment.id == commentId,
    );
    if (index == -1 || _comments[index].authorId != authorId) {
      throw StateError('수정할 수 없는 댓글입니다.');
    }

    _comments[index] = _comments[index].copyWith(content: content);
  }

  @override
  Future<void> deleteComment({
    required String commentId,
    required String authorId,
  }) async {
    final ItemComment? comment = _comments
        .where((entry) => entry.id == commentId)
        .firstOrNull;
    if (comment == null || comment.authorId != authorId) {
      throw StateError('삭제할 수 없는 댓글입니다.');
    }

    final Set<String> deletedIds = {commentId};
    for (final ItemComment entry in _comments) {
      if (entry.parentCommentId == commentId) {
        deletedIds.add(entry.id);
      }
    }
    _comments.removeWhere((entry) => deletedIds.contains(entry.id));
  }

  @override
  Future<TradeRequest> createTradeRequest({
    required String itemId,
    required String requesterId,
    required String requesterName,
  }) async {
    final TradeItem item = _item(itemId);
    if (item.ownerId == requesterId) {
      throw StateError('내 물건에는 요청할 수 없습니다.');
    }
    if (!item.isActive) {
      throw StateError('거래가 완료된 물건입니다.');
    }
    if (_requests.any(
      (request) =>
          request.itemId == itemId &&
          request.requesterId == requesterId &&
          request.status == TradeRequestStatus.pending,
    )) {
      throw StateError('이미 요청한 물건입니다.');
    }

    final TradeRequest request = TradeRequest(
      id: _newId('request'),
      itemId: itemId,
      requesterId: requesterId,
      requesterName: requesterName,
      createdAt: DateTime.now(),
    );
    _requests.add(request);
    _notifications.insert(
      0,
      AppNotification(
        id: _newId('notification'),
        userId: item.ownerId,
        type: AppNotificationType.request,
        title: '${item.tradeMethod.label} 요청',
        content: '$requesterName님이 ${item.title}에 요청을 보냈어요.',
        createdAt: DateTime.now(),
        relatedItemId: item.id,
        relatedRequestId: request.id,
      ),
    );

    return request;
  }

  @override
  Future<void> updateTradeRequestStatus({
    required String requestId,
    required TradeRequestStatus status,
  }) async {
    final int requestIndex = _requests.indexWhere(
      (request) => request.id == requestId,
    );
    if (requestIndex == -1) {
      throw StateError('거래 요청을 찾을 수 없습니다.');
    }

    final TradeRequest request = _requests[requestIndex];
    if (request.status != TradeRequestStatus.pending) {
      throw StateError('이미 처리된 요청입니다.');
    }

    _requests[requestIndex] = request.copyWith(status: status);
    final TradeItem item = _item(request.itemId);
    if (status == TradeRequestStatus.accepted) {
      await updateItemStatus(item.id, ItemTradeStatus.completed);
    }

    _notifications.insert(
      0,
      AppNotification(
        id: _newId('notification'),
        userId: request.requesterId,
        type: AppNotificationType.request,
        title: status == TradeRequestStatus.accepted ? '요청 수락' : '요청 거절',
        content:
            '${item.title}에 대한 요청이 '
            '${status == TradeRequestStatus.accepted ? '수락' : '거절'}되었어요.',
        createdAt: DateTime.now(),
        relatedItemId: item.id,
        relatedRequestId: request.id,
      ),
    );
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    final int index = _notifications.indexWhere(
      (notification) => notification.id == notificationId,
    );
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<Notice> createNotice({
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  }) async {
    final Notice notice = Notice(
      id: _newId('notice'),
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
    );
    _notices.insert(0, notice);
    _notifications.insert(
      0,
      AppNotification(
        id: _newId('notification'),
        userId: 'fake-user-1',
        type: AppNotificationType.notice,
        title: '공지사항',
        content: title,
        createdAt: createdAt,
        relatedNoticeId: notice.id,
      ),
    );
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
    final int index = _noticeIndex(noticeId);
    _notices[index] = _notices[index].copyWith(
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> deleteNotice(String noticeId) async {
    _notices.removeWhere((notice) => notice.id == noticeId);
    _notifications.removeWhere(
      (notification) => notification.relatedNoticeId == noticeId,
    );
  }

  @override
  Future<void> updateOwnerProfile({
    required String ownerId,
    required String ownerName,
    required String ownerGeneration,
  }) async {
    for (int index = 0; index < _items.length; index++) {
      if (_items[index].ownerId == ownerId) {
        _items[index] = _items[index].copyWith(
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

  TradeItem _item(String itemId) {
    return _items.firstWhere(
      (item) => item.id == itemId,
      orElse: () => throw StateError('물건을 찾을 수 없습니다.'),
    );
  }

  int _itemIndex(String itemId) {
    final int index = _items.indexWhere((item) => item.id == itemId);
    if (index == -1) throw StateError('물건을 찾을 수 없습니다.');
    return index;
  }

  int _noticeIndex(String noticeId) {
    final int index = _notices.indexWhere((notice) => notice.id == noticeId);
    if (index == -1) throw StateError('공지를 찾을 수 없습니다.');
    return index;
  }

  String _newId(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}
