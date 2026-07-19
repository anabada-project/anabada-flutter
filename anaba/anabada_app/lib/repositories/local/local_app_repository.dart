import '../../models/app_notification.dart';
import '../../models/item_comment.dart';
import '../../models/notice.dart';
import '../../models/trade_item.dart';
import '../../models/trade_request.dart';
import '../app_repository.dart';
import 'local_comment_repository.dart';
import 'local_item_repository.dart';
import 'local_notice_repository.dart';
import 'local_store.dart';
import 'local_trade_repository.dart';

class LocalAppRepository implements AppRepository {
  LocalAppRepository({LocalStore? store})
    : _store = store ?? LocalStore.seeded() {
    _items = LocalItemRepository(_store);
    _comments = LocalCommentRepository(_store);
    _notices = LocalNoticeRepository(_store);
    _trades = LocalTradeRepository(_store);
  }

  final LocalStore _store;
  late final LocalItemRepository _items;
  late final LocalCommentRepository _comments;
  late final LocalNoticeRepository _notices;
  late final LocalTradeRepository _trades;

  @override
  List<TradeItem> get cachedItems => List.unmodifiable(_store.items);

  @override
  List<ItemComment> get cachedComments => List.unmodifiable(_store.comments);

  @override
  List<AppNotification> get cachedNotifications {
    return List.unmodifiable(_store.notifications);
  }

  @override
  List<Notice> get cachedNotices => List.unmodifiable(_store.notices);

  @override
  List<TradeRequest> get cachedRequests {
    return List.unmodifiable(_store.requests);
  }

  @override
  List<String> recentItemIdsFor(String userId) {
    return List.unmodifiable(_store.recentItemIds[userId] ?? const []);
  }

  @override
  Future<void> refresh() async {}

  @override
  Future<List<TradeItem>> fetchUserItems(String userId) async {
    return _store.items
        .where((item) => item.ownerId == userId)
        .toList(growable: false);
  }

  @override
  Future<TradeItem> createItem(CreateTradeItemInput input) {
    return _items.create(input);
  }

  @override
  Future<void> updateItemStatus(String itemId, ItemTradeStatus status) {
    return _items.updateStatus(itemId, status);
  }

  @override
  Future<void> deleteItem(String itemId) {
    return _items.delete(itemId);
  }

  @override
  Future<void> setItemLiked({
    required String itemId,
    required String userId,
    required String userName,
    required bool isLiked,
  }) {
    return _items.setLiked(
      itemId: itemId,
      userId: userId,
      userName: userName,
      isLiked: isLiked,
    );
  }

  @override
  Future<void> recordItemView({
    required String itemId,
    required String userId,
  }) {
    return _items.recordView(itemId: itemId, userId: userId);
  }

  @override
  Future<ItemComment> createComment({
    required String itemId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentCommentId,
  }) {
    return _comments.create(
      itemId: itemId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      parentCommentId: parentCommentId,
    );
  }

  @override
  Future<void> updateComment({
    required String commentId,
    required String itemId,
    required String authorId,
    required String content,
  }) {
    return _comments.update(
      commentId: commentId,
      authorId: authorId,
      content: content,
    );
  }

  @override
  Future<void> deleteComment({
    required String commentId,
    required String authorId,
  }) {
    return _comments.delete(commentId: commentId, authorId: authorId);
  }

  @override
  Future<TradeRequest> createTradeRequest({
    required String itemId,
    required String requesterId,
    required String requesterName,
  }) {
    return _trades.create(
      itemId: itemId,
      requesterId: requesterId,
      requesterName: requesterName,
    );
  }

  @override
  Future<void> updateTradeRequestStatus({
    required String requestId,
    required TradeRequestStatus status,
  }) {
    return _trades.updateStatus(requestId: requestId, status: status);
  }

  @override
  Future<void> markNotificationRead(String notificationId) {
    return _notices.markNotificationRead(notificationId);
  }

  @override
  Future<Notice> createNotice({
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  }) {
    return _notices.create(
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> updateNotice({
    required String noticeId,
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  }) {
    return _notices.update(
      noticeId: noticeId,
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> deleteNotice(String noticeId) {
    return _notices.delete(noticeId);
  }

  @override
  Future<void> updateOwnerProfile({
    required String ownerId,
    required String ownerName,
    required String ownerGeneration,
  }) async {
    await _items.updateOwnerProfile(
      ownerId: ownerId,
      ownerName: ownerName,
      ownerGeneration: ownerGeneration,
    );
    await _comments.updateAuthorName(authorId: ownerId, authorName: ownerName);
  }
}
