import '../../../models/trade_item.dart';

class TradeItemMapper {
  const TradeItemMapper._();

  static TradeItem fromJson(
    Map<String, dynamic> json, {
    TradeItem? fallback,
    String? currentUserId,
    required String Function() fallbackId,
  }) {
    final List<String> imageUrls = _stringList(
      json['imageUrls'] ?? json['images'] ?? json['imageUrl'],
    );
    final Set<String> likedUserIds = {...?fallback?.likedUserIds};
    final bool? isLiked = _boolValue(json['isLiked'] ?? json['liked']);
    final int? likeCount = _intValue(json['likeCount'] ?? json['likes']);

    if (isLiked == true && currentUserId != null && currentUserId.isNotEmpty) {
      likedUserIds.add(currentUserId);
    }
    _syncLikeCount(likedUserIds, likeCount);

    return TradeItem(
      id:
          _stringValue(json['id'] ?? json['productId'] ?? json['product_id']) ??
          fallback?.id ??
          fallbackId(),
      title:
          _stringValue(json['title'] ?? json['name']) ?? fallback?.title ?? '',
      description:
          _stringValue(json['content'] ?? json['description']) ??
          fallback?.description ??
          '',
      wantedItem:
          _stringValue(json['hopeItem'] ?? json['wantedItem']) ??
          fallback?.wantedItem ??
          '',
      category:
          categoryFromApi(json['category']) ??
          fallback?.category ??
          ItemCategory.etc,
      tradeMethod:
          tradeMethodFromApi(json['tradeType'] ?? json['tradeMethod']) ??
          fallback?.tradeMethod ??
          TradeMethod.exchange,
      status:
          statusFromApi(json['status']) ??
          fallback?.status ??
          ItemTradeStatus.available,
      ownerId:
          _stringValue(json['userId'] ?? json['ownerId'] ?? json['writerId']) ??
          fallback?.ownerId ??
          '',
      ownerName:
          _stringValue(
            json['userName'] ?? json['ownerName'] ?? json['writer'],
          ) ??
          fallback?.ownerName ??
          '',
      ownerGeneration:
          _stringValue(json['generation'] ?? json['userGeneration']) ??
          fallback?.ownerGeneration ??
          '',
      createdAt:
          _dateValue(json['createdAt'] ?? json['created_at']) ??
          fallback?.createdAt ??
          DateTime.now(),
      imageUrl: imageUrls.isEmpty ? fallback?.imageUrl : imageUrls.first,
      likedUserIds: likedUserIds,
    );
  }

  static Map<String, Object?> createBody(
    CreateTradeItemInput input,
    List<String> imageUrls,
  ) {
    return {
      'title': input.title,
      'content': input.description,
      'price': 0,
      'hopeItem': input.wantedItem,
      'tradeType': tradeTypeToApi(input.tradeMethod),
      'category': categoryToApi(input.category),
      'imageUrls': imageUrls,
    };
  }

  static Map<String, Object?> updateBody(TradeItem item) {
    return {
      'title': item.title,
      'content': item.description,
      'price': 0,
      'hopeItem': item.wantedItem,
      'tradeType': tradeTypeToApi(item.tradeMethod),
      'category': categoryToApi(item.category),
      'status': statusToApi(item.status),
      'imageUrls': item.imageUrl == null ? const [] : [item.imageUrl],
    };
  }

  static String categoryToApi(ItemCategory category) {
    return switch (category) {
      ItemCategory.food => 'FOOD',
      ItemCategory.clothes => 'CLOTHES',
      ItemCategory.book => 'BOOK',
      ItemCategory.etc => 'ETC',
    };
  }

  static ItemCategory? categoryFromApi(dynamic value) {
    return switch (_stringValue(value)?.toUpperCase()) {
      'FOOD' || '식품' => ItemCategory.food,
      'CLOTHES' || 'CLOTHING' || '의류' => ItemCategory.clothes,
      'BOOK' || 'BOOKS' || '도서' => ItemCategory.book,
      'ETC' || 'OTHER' || '기타' => ItemCategory.etc,
      _ => null,
    };
  }

  static String tradeTypeToApi(TradeMethod tradeMethod) {
    return switch (tradeMethod) {
      TradeMethod.exchange => 'EXCHANGE',
      TradeMethod.share => 'SHARE',
    };
  }

  static TradeMethod? tradeMethodFromApi(dynamic value) {
    return switch (_stringValue(value)?.toUpperCase()) {
      'SHARE' || '나눔' => TradeMethod.share,
      'EXCHANGE' || 'TRADE' || '교환' => TradeMethod.exchange,
      _ => null,
    };
  }

  static String statusToApi(ItemTradeStatus status) {
    return switch (status) {
      ItemTradeStatus.available => 'ACTIVE',
      ItemTradeStatus.completed => 'COMPLETED',
    };
  }

  static ItemTradeStatus? statusFromApi(dynamic value) {
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

  static void _syncLikeCount(Set<String> likedUserIds, int? likeCount) {
    if (likeCount == null) return;

    if (likeCount > likedUserIds.length) {
      for (int index = likedUserIds.length; index < likeCount; index++) {
        likedUserIds.add('like-user-$index');
      }
      return;
    }

    int removeCount = likedUserIds.length - likeCount;
    final List<String> dummyIds = likedUserIds
        .where((id) => id.startsWith('like-user-'))
        .toList(growable: false);
    for (final String id in dummyIds) {
      if (removeCount <= 0) break;
      likedUserIds.remove(id);
      removeCount--;
    }
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

  static String? _stringValue(dynamic value) => value?.toString();

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
}
