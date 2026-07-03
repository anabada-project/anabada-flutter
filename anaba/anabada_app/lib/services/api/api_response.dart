typedef JsonMap = Map<String, dynamic>;
typedef JsonMapper<T> = T Function(JsonMap json);
typedef ApiResponseParser<T> = T Function(dynamic response);

class ApiResponse<T> {
  const ApiResponse({required this.raw, required this.data});

  factory ApiResponse.fromRaw(
    dynamic response, {
    required ApiResponseParser<T> parser,
  }) {
    return ApiResponse<T>(raw: response, data: parser(response));
  }

  final dynamic raw;
  final T data;

  static dynamic dataOf(dynamic response) {
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'];
    }
    return response;
  }

  static JsonMap? dataMap(dynamic response) {
    final dynamic data = dataOf(response);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  static T parseData<T>(dynamic response, JsonMapper<T> mapper) {
    return mapper(dataMap(response) ?? const <String, dynamic>{});
  }

  static List<T> parseList<T>(
    dynamic response,
    JsonMapper<T> mapper, {
    List<String> listKeys = const ['content', 'items', 'posts'],
  }) {
    return dataList(
      response,
      listKeys: listKeys,
    ).map(mapper).toList(growable: false);
  }

  static List<JsonMap> dataList(
    dynamic response, {
    List<String> listKeys = const ['content', 'items', 'posts'],
  }) {
    final dynamic data = dataOf(response);
    if (data is List) return mapList(data);

    final JsonMap? map = dataMap(response);
    if (map == null) return const [];

    for (final String key in listKeys) {
      if (map[key] is List) return mapList(map[key]);
    }

    return map.isEmpty ? const [] : [map];
  }

  static List<JsonMap> mapList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList(growable: false);
  }

  static bool hasList(JsonMap map, List<String> keys) {
    return keys.any((key) => map[key] is List);
  }
}
