import 'dart:typed_data';

enum ItemCategory {
  food('식품'),
  clothes('의류'),
  book('도서'),
  etc('기타');

  const ItemCategory(this.label);

  final String label;
}

enum TradeMethod {
  exchange('교환'),
  share('나눔');

  const TradeMethod(this.label);

  final String label;
}

enum ItemTradeStatus { available, completed }

class TradeItem {
  const TradeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tradeMethod,
    required this.status,
    required this.ownerId,
    required this.ownerName,
    required this.ownerGeneration,
    required this.createdAt,
    this.wantedItem = '',
    this.imageBytes,
    this.imageUrl,
    this.likedUserIds = const <String>{},
  });

  final String id;
  final String title;
  final String description;
  final String wantedItem;
  final ItemCategory category;
  final TradeMethod tradeMethod;
  final ItemTradeStatus status;
  final String ownerId;
  final String ownerName;
  final String ownerGeneration;
  final DateTime createdAt;
  final Uint8List? imageBytes;
  final String? imageUrl;
  final Set<String> likedUserIds;

  bool get isActive => status == ItemTradeStatus.available;

  int get likeCount => likedUserIds.length;

  String get statusLabel => '${tradeMethod.label} ${isActive ? '가능' : '완료'}';

  bool isLikedBy(String userId) => likedUserIds.contains(userId);

  TradeItem copyWith({
    String? title,
    String? description,
    String? wantedItem,
    ItemCategory? category,
    TradeMethod? tradeMethod,
    ItemTradeStatus? status,
    String? ownerName,
    String? ownerGeneration,
    Uint8List? imageBytes,
    String? imageUrl,
    Set<String>? likedUserIds,
  }) {
    return TradeItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      wantedItem: wantedItem ?? this.wantedItem,
      category: category ?? this.category,
      tradeMethod: tradeMethod ?? this.tradeMethod,
      status: status ?? this.status,
      ownerId: ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerGeneration: ownerGeneration ?? this.ownerGeneration,
      createdAt: createdAt,
      imageBytes: imageBytes ?? this.imageBytes,
      imageUrl: imageUrl ?? this.imageUrl,
      likedUserIds: likedUserIds ?? this.likedUserIds,
    );
  }
}

class CreateTradeItemInput {
  const CreateTradeItemInput({
    required this.title,
    required this.description,
    required this.wantedItem,
    required this.category,
    required this.tradeMethod,
    required this.ownerId,
    required this.ownerName,
    required this.ownerGeneration,
    required this.imageBytes,
    this.imagePath,
  });

  final String title;
  final String description;
  final String wantedItem;
  final ItemCategory category;
  final TradeMethod tradeMethod;
  final String ownerId;
  final String ownerName;
  final String ownerGeneration;
  final Uint8List imageBytes;
  final String? imagePath;
}
