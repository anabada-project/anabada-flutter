import 'package:flutter/foundation.dart';

import '../models/app_notification.dart';
import '../models/item_comment.dart';
import '../models/notice.dart';
import '../models/trade_item.dart';
import '../models/trade_request.dart';
import '../repositories/app_repository.dart';
import '../repositories/api/api_app_repository.dart';
import '../services/api/api_client.dart';
import '../services/auth_service.dart';

final AppController appController = AppController(
  ApiAppRepository(
    ApiClient(tokenProvider: () => authService.accessToken),
    currentUserIdProvider: () => authService.currentUser?.id,
  ),
);

class AppController extends ChangeNotifier {
  AppController(this._repository) {
    _syncCache();
  }

  final AppRepository _repository;

  List<TradeItem> _items = const [];
  List<ItemComment> _comments = const [];
  List<AppNotification> _notifications = const [];
  List<Notice> _notices = const [];
  List<TradeRequest> _requests = const [];

  List<TradeItem> get items => List.unmodifiable(_items);

  List<Notice> get notices => List.unmodifiable(_notices);

  List<TradeRequest> get requests => List.unmodifiable(_requests);

  TradeItem? itemById(String itemId) {
    for (final TradeItem item in _items) {
      if (item.id == itemId) return item;
    }
    return null;
  }

  Notice? noticeById(String noticeId) {
    for (final Notice notice in _notices) {
      if (notice.id == noticeId) return notice;
    }
    return null;
  }

  List<TradeItem> favoriteItems(String userId) {
    return _items.where((item) => item.isLikedBy(userId)).toList();
  }

  List<TradeItem> userItems(String userId) {
    return _items.where((item) => item.ownerId == userId).toList();
  }

  List<TradeItem> recentItems(String userId) {
    final List<String> ids = _repository.recentItemIdsFor(userId);
    return ids.map(itemById).whereType<TradeItem>().toList(growable: false);
  }

  List<ItemComment> commentsFor(String itemId) {
    return _comments
        .where((comment) => comment.itemId == itemId)
        .toList(growable: false);
  }

  ItemComment? commentById(String commentId) {
    for (final ItemComment comment in _comments) {
      if (comment.id == commentId) return comment;
    }
    return null;
  }

  List<AppNotification> notificationsFor(String userId) {
    return _notifications
        .where((notification) => notification.userId == userId)
        .toList(growable: false);
  }

  Future<void> refresh() async {
    await _repository.refresh();
    _notifyFromRepository();
  }

  Future<List<TradeItem>> fetchUserItems(String userId) async {
    final List<TradeItem> items = await _repository.fetchUserItems(userId);
    _notifyFromRepository();
    return items;
  }

  Future<TradeItem> createItem(CreateTradeItemInput input) async {
    final TradeItem item = await _repository.createItem(input);
    _notifyFromRepository();
    return item;
  }

  Future<void> updateItemStatus(String itemId, ItemTradeStatus status) async {
    await _repository.updateItemStatus(itemId, status);
    _notifyFromRepository();
  }

  Future<void> deleteItem(String itemId) async {
    await _repository.deleteItem(itemId);
    _notifyFromRepository();
  }

  Future<void> toggleLike({
    required String itemId,
    required String userId,
    required String userName,
  }) async {
    final TradeItem? item = itemById(itemId);
    if (item == null) return;

    await _repository.setItemLiked(
      itemId: itemId,
      userId: userId,
      userName: userName,
      isLiked: !item.isLikedBy(userId),
    );
    _notifyFromRepository();
  }

  Future<void> recordItemView({
    required String itemId,
    required String userId,
  }) async {
    await _repository.recordItemView(itemId: itemId, userId: userId);
    notifyListeners();
  }

  Future<ItemComment> createComment({
    required String itemId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentCommentId,
  }) async {
    final ItemComment comment = await _repository.createComment(
      itemId: itemId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      parentCommentId: parentCommentId,
    );
    _notifyFromRepository();
    return comment;
  }

  Future<void> updateComment({
    required String commentId,
    required String authorId,
    required String content,
  }) async {
    await _repository.updateComment(
      commentId: commentId,
      authorId: authorId,
      content: content,
    );
    _notifyFromRepository();
  }

  Future<void> deleteComment({
    required String commentId,
    required String authorId,
  }) async {
    await _repository.deleteComment(commentId: commentId, authorId: authorId);
    _notifyFromRepository();
  }

  Future<TradeRequest> createTradeRequest({
    required String itemId,
    required String requesterId,
    required String requesterName,
  }) async {
    final TradeRequest request = await _repository.createTradeRequest(
      itemId: itemId,
      requesterId: requesterId,
      requesterName: requesterName,
    );
    _notifyFromRepository();
    return request;
  }

  Future<void> updateTradeRequestStatus({
    required String requestId,
    required TradeRequestStatus status,
  }) async {
    await _repository.updateTradeRequestStatus(
      requestId: requestId,
      status: status,
    );
    _notifyFromRepository();
  }

  Future<void> markNotificationRead(String notificationId) async {
    await _repository.markNotificationRead(notificationId);
    _notifyFromRepository();
  }

  Future<Notice> createNotice({
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  }) async {
    final Notice notice = await _repository.createNotice(
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
    );
    _notifyFromRepository();
    return notice;
  }

  Future<void> updateNotice({
    required String noticeId,
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  }) async {
    await _repository.updateNotice(
      noticeId: noticeId,
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
    );
    _notifyFromRepository();
  }

  Future<void> deleteNotice(String noticeId) async {
    await _repository.deleteNotice(noticeId);
    _notifyFromRepository();
  }

  Future<void> updateOwnerProfile({
    required String ownerId,
    required String ownerName,
    required String ownerGeneration,
  }) async {
    await _repository.updateOwnerProfile(
      ownerId: ownerId,
      ownerName: ownerName,
      ownerGeneration: ownerGeneration,
    );
    _notifyFromRepository();
  }

  void _notifyFromRepository() {
    _syncCache();
    notifyListeners();
  }

  void _syncCache() {
    _items = _repository.cachedItems;
    _comments = _repository.cachedComments;
    _notifications = _repository.cachedNotifications;
    _notices = _repository.cachedNotices;
    _requests = _repository.cachedRequests;
  }
}
