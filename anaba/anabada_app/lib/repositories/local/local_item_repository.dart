import '../../models/app_notification.dart';
import '../../models/trade_item.dart';
import 'local_store.dart';

class LocalItemRepository {
  const LocalItemRepository(this._store);

  final LocalStore _store;

  Future<TradeItem> create(CreateTradeItemInput input) async {
    final TradeItem item = TradeItem(
      id: _store.newId('item'),
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
    _store.items.insert(0, item);
    return item;
  }

  Future<void> updateStatus(
    String itemId,
    ItemTradeStatus status,
  ) async {
    final int index = _store.itemIndex(itemId);
    _store.items[index] = _store.items[index].copyWith(status: status);
  }

  Future<void> delete(String itemId) async {
    _store.items.removeWhere((item) => item.id == itemId);
    _store.comments.removeWhere((comment) => comment.itemId == itemId);
    _store.requests.removeWhere((request) => request.itemId == itemId);
    for (final List<String> ids in _store.recentItemIds.values) {
      ids.remove(itemId);
    }
  }

  Future<void> setLiked({
    required String itemId,
    required String userId,
    required String userName,
    required bool isLiked,
  }) async {
    final int index = _store.itemIndex(itemId);
    final TradeItem item = _store.items[index];
    final Set<String> likedUserIds = {...item.likedUserIds};
    isLiked ? likedUserIds.add(userId) : likedUserIds.remove(userId);
    _store.items[index] = item.copyWith(likedUserIds: likedUserIds);

    if (isLiked && item.ownerId != userId) {
      _store.notifications.insert(
        0,
        AppNotification(
          id: _store.newId('notification'),
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

  Future<void> recordView({
    required String itemId,
    required String userId,
  }) async {
    final List<String> ids = _store.recentItemIds.putIfAbsent(
      userId,
      () => [],
    );
    ids
      ..remove(itemId)
      ..insert(0, itemId);
    if (ids.length > 20) ids.removeRange(20, ids.length);
  }

  Future<void> updateOwnerProfile({
    required String ownerId,
    required String ownerName,
    required String ownerGeneration,
  }) async {
    for (int index = 0; index < _store.items.length; index++) {
      if (_store.items[index].ownerId == ownerId) {
        _store.items[index] = _store.items[index].copyWith(
          ownerName: ownerName,
          ownerGeneration: ownerGeneration,
        );
      }
    }
  }
}
