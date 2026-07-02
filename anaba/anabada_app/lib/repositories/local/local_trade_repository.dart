import '../../models/app_notification.dart';
import '../../models/trade_item.dart';
import '../../models/trade_request.dart';
import 'local_store.dart';

class LocalTradeRepository {
  const LocalTradeRepository(this._store);

  final LocalStore _store;

  Future<TradeRequest> create({
    required String itemId,
    required String requesterId,
    required String requesterName,
  }) async {
    final TradeItem item = _store.itemById(itemId);
    if (item.ownerId == requesterId) {
      throw StateError('내 물건에는 요청할 수 없습니다.');
    }
    if (!item.isActive) {
      throw StateError('거래가 완료된 물건입니다.');
    }
    if (_store.requests.any(
      (request) =>
          request.itemId == itemId &&
          request.requesterId == requesterId &&
          request.status == TradeRequestStatus.pending,
    )) {
      throw StateError('이미 요청한 물건입니다.');
    }

    final TradeRequest request = TradeRequest(
      id: _store.newId('request'),
      itemId: itemId,
      requesterId: requesterId,
      requesterName: requesterName,
      createdAt: DateTime.now(),
    );
    _store.requests.add(request);
    _store.notifications.insert(
      0,
      AppNotification(
        id: _store.newId('notification'),
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

  Future<void> updateStatus({
    required String requestId,
    required TradeRequestStatus status,
  }) async {
    final int requestIndex = _store.requests.indexWhere(
      (request) => request.id == requestId,
    );
    if (requestIndex == -1) {
      throw StateError('거래 요청을 찾을 수 없습니다.');
    }

    final TradeRequest request = _store.requests[requestIndex];
    if (request.status != TradeRequestStatus.pending) {
      throw StateError('이미 처리된 요청입니다.');
    }

    _store.requests[requestIndex] = request.copyWith(status: status);
    final TradeItem item = _store.itemById(request.itemId);
    if (status == TradeRequestStatus.accepted) {
      final int itemIndex = _store.itemIndex(item.id);
      _store.items[itemIndex] = item.copyWith(
        status: ItemTradeStatus.completed,
      );
    }

    _store.notifications.insert(
      0,
      AppNotification(
        id: _store.newId('notification'),
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
}
