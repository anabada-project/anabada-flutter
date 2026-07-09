import 'api_client.dart';
import 'api_response.dart';

class PostApi {
  const PostApi(this._client);

  final ApiClient _client;

  Future<ApiResponse<List<T>>> fetchAll<T>(JsonMapper<T> mapper) {
    return _client.getResponse<List<T>>(
      '/api/post',
      authenticated: false,
      parser: (response) => ApiResponse.parseList(response, mapper),
    );
  }

  Future<ApiResponse<T>> fetchOne<T>(String postId, JsonMapper<T> mapper) {
    return _client.getResponse<T>(
      '/api/post/$postId',
      authenticated: false,
      parser: (response) => ApiResponse.parseData(response, mapper),
    );
  }

  Future<ApiResponse<List<T>>> fetchRecent<T>(JsonMapper<T> mapper) {
    return _client.getResponse<List<T>>(
      '/api/post/recent',
      parser: (response) => ApiResponse.parseList(response, mapper),
    );
  }

  Future<ApiResponse<T>> create<T>(
    Map<String, Object?> body,
    JsonMapper<T> mapper,
  ) {
    return _client.postResponse<T>(
      '/api/post',
      body: body,
      parser: (response) => ApiResponse.parseData(response, mapper),
    );
  }

  Future<ApiResponse<T>> update<T>(
    String postId,
    Map<String, Object?> body,
    JsonMapper<T> mapper,
  ) {
    return _client.putResponse<T>(
      '/api/post/$postId',
      body: body,
      parser: (response) => ApiResponse.parseData(response, mapper),
    );
  }

  Future<void> delete(String postId) async {
    await _client.delete('/api/post/$postId');
  }
}
