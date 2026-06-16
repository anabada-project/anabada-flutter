class ApiClient {
  static const String baseUrl = 'https://anabada.shop';

  static Uri uri(String path) {
    return Uri.parse('$baseUrl$path');
  }

  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  static Map<String, String> authHeaders(String accessToken) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }
}
