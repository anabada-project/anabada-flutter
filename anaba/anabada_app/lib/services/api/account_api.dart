import 'api_client.dart';
import 'api_response.dart';

class AccountApi {
  const AccountApi(this._client);

  final ApiClient _client;

  Future<ApiResponse<List<T>>> fetchPosts<T>(JsonMapper<T> mapper) {
    return _client.getResponse<List<T>>(
      '/api/account/posts',
      parser: (response) => ApiResponse.parseList(response, mapper),
    );
  }
}
