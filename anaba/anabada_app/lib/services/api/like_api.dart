import 'api_client.dart';

class LikeApi {
  const LikeApi(this._client);

  final ApiClient _client;

  Future<void> setLiked({required String itemId, required bool isLiked}) async {
    await _client.post('/api/like/$itemId');
  }
}
