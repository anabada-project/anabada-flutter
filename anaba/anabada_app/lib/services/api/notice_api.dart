import 'api_client.dart';
import 'api_response.dart';

class NoticeApi {
  const NoticeApi(this._client);

  final ApiClient _client;

  Future<ApiResponse<List<T>>> fetchAll<T>(JsonMapper<T> mapper) {
    return _client.getResponse<List<T>>(
      '/api/notice',
      authenticated: false,
      parser: (response) => ApiResponse.parseList(
        response,
        mapper,
        listKeys: const ['content', 'notices'],
      ),
    );
  }

  Future<ApiResponse<T>> fetchOne<T>(String noticeId, JsonMapper<T> mapper) {
    return _client.getResponse<T>(
      '/api/notice/$noticeId',
      authenticated: false,
      parser: (response) => ApiResponse.parseData(response, mapper),
    );
  }

  Future<ApiResponse<T>> create<T>({
    required String title,
    required String content,
    required JsonMapper<T> mapper,
  }) {
    return _client.postResponse<T>(
      '/api/notice',
      body: {'title': title, 'content': content},
      parser: (response) => ApiResponse.parseData(response, mapper),
    );
  }

  Future<ApiResponse<T>> update<T>({
    required String noticeId,
    required String title,
    required String content,
    required JsonMapper<T> mapper,
  }) {
    return _client.patchResponse<T>(
      '/api/notice/$noticeId',
      body: {'title': title, 'content': content},
      parser: (response) => ApiResponse.parseData(response, mapper),
    );
  }

  Future<void> delete(String noticeId) async {
    await _client.delete('/api/notice/$noticeId');
  }
}
