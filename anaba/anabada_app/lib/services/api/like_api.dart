import 'api_client.dart';

class LikeApi {
  const LikeApi(this._client);

  final ApiClient _client;

  Future<void> setLiked({required String itemId, required bool isLiked}) async {
    if (isLiked) {
      await _client.post('/api/like/$itemId');
    } else {
      await _client.delete('/api/like/$itemId');
    }
  }
}
