import 'api_client.dart';
import 'api_response.dart';

class RecentApi {
  const RecentApi(this._client);

  final ApiClient _client;

  Future<ApiResponse<RecentViewedProduct>> fetchViewedProduct({
    required String productId,
  }) {
    return _client.getResponse<RecentViewedProduct>(
      '/api/recent',
      queryParameters: {'product_id': productId},
      parser: (response) =>
          ApiResponse.parseData(response, RecentViewedProduct.fromJson),
    );
  }
}

class RecentViewedProduct {
  const RecentViewedProduct({
    required this.title,
    this.commentTime,
    this.price,
  });

  factory RecentViewedProduct.fromJson(JsonMap json) {
    return RecentViewedProduct(
      title: json['title']?.toString() ?? '',
      commentTime: json['comment_time']?.toString(),
      price: _intValue(json['price']),
    );
  }

  final String title;
  final String? commentTime;
  final int? price;

  static int? _intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
