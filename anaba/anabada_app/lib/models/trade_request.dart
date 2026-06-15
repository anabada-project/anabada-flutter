enum TradeRequestStatus { pending, accepted, rejected }

class TradeRequest {
  const TradeRequest({
    required this.id,
    required this.itemId,
    required this.requesterId,
    required this.requesterName,
    required this.createdAt,
    this.status = TradeRequestStatus.pending,
  });

  final String id;
  final String itemId;
  final String requesterId;
  final String requesterName;
  final DateTime createdAt;
  final TradeRequestStatus status;

  TradeRequest copyWith({TradeRequestStatus? status}) {
    return TradeRequest(
      id: id,
      itemId: itemId,
      requesterId: requesterId,
      requesterName: requesterName,
      createdAt: createdAt,
      status: status ?? this.status,
    );
  }
}
