import 'api_client.dart';
import 'api_response.dart';

class CommentApi {
  const CommentApi(this._client);

  final ApiClient _client;

  Future<ApiResponse<List<T>>> fetchThread<T>(
    String commentId,
    JsonMapper<T> mapper,
  ) {
    return _client.getResponse<List<T>>(
      '/api/comment/$commentId',
      parser: (response) => ApiResponse.parseList(
        response,
        mapper,
        listKeys: const ['content', 'comments', 'replies'],
      ),
    );
  }

  Future<ApiResponse<T>> create<T>({
    required String itemId,
    required String content,
    required JsonMapper<T> mapper,
  }) {
    final Object productId = int.tryParse(itemId) ?? itemId;

    return _client.postResponse<T>(
      '/api/comment',
      body: {'product_id': productId, 'comment_content': content},
      parser: (response) => ApiResponse.parseData(response, mapper),
    );
  }

  Future<ApiResponse<T>> createReply<T>({
    required String parentCommentId,
    required String content,
    required JsonMapper<T> mapper,
  }) {
    return _client.postResponse<T>(
      '/api/comment/$parentCommentId',
      body: {'content': content},
      parser: (response) => ApiResponse.parseData(response, mapper),
    );
  }

  Future<ApiResponse<T>> update<T>({
    required String commentId,
    required String itemId,
    required String content,
    required JsonMapper<T> mapper,
  }) {
    final Object productId = int.tryParse(itemId) ?? itemId;

    return _client.patchResponse<T>(
      '/api/comment/$commentId',
      body: {'product_id': productId, 'comment_content': content},
      parser: (response) => ApiResponse.parseData(response, mapper),
    );
  }

  Future<void> delete(String commentId) async {
    await _client.delete('/api/comment/$commentId');
  }
}
