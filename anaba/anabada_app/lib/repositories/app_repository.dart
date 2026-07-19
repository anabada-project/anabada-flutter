import '../models/app_notification.dart';
import '../models/item_comment.dart';
import '../models/notice.dart';
import '../models/trade_item.dart';
import '../models/trade_request.dart';

abstract class AppRepository {
  List<TradeItem> get cachedItems;

  List<ItemComment> get cachedComments;

  List<AppNotification> get cachedNotifications;

  List<Notice> get cachedNotices;

  List<TradeRequest> get cachedRequests;

  List<String> recentItemIdsFor(String userId);

  Future<void> refresh();

  Future<List<TradeItem>> fetchUserItems(String userId);

  Future<TradeItem> createItem(CreateTradeItemInput input);

  Future<void> updateItemStatus(String itemId, ItemTradeStatus status);

  Future<void> deleteItem(String itemId);

  Future<void> setItemLiked({
    required String itemId,
    required String userId,
    required String userName,
    required bool isLiked,
  });

  Future<void> recordItemView({required String itemId, required String userId});

  Future<ItemComment> createComment({
    required String itemId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentCommentId,
  });

  Future<void> updateComment({
    required String commentId,
    required String itemId,
    required String authorId,
    required String content,
  });

  Future<void> deleteComment({
    required String commentId,
    required String authorId,
  });

  Future<TradeRequest> createTradeRequest({
    required String itemId,
    required String requesterId,
    required String requesterName,
  });

  Future<void> updateTradeRequestStatus({
    required String requestId,
    required TradeRequestStatus status,
  });

  Future<void> markNotificationRead(String notificationId);

  Future<Notice> createNotice({
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  });

  Future<void> updateNotice({
    required String noticeId,
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
  });

  Future<void> deleteNotice(String noticeId);

  Future<void> updateOwnerProfile({
    required String ownerId,
    required String ownerName,
    required String ownerGeneration,
  });
}
