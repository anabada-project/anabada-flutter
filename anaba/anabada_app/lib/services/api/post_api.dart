import 'dart:typed_data';

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

  Future<List<String>> uploadImages({
    required String filename,
    required String contentType,
    required Uint8List bytes,
  }) async {
    final ApiResponse<List<_PresignedUpload>> response = await _client
        .postResponse<List<_PresignedUpload>>(
      '/api/post/presigned-urls',
      body: {
        'filenames': [filename],
        'contentTypes': [contentType],
      },
      parser: (response) => ApiResponse.parseList(
        response,
        _PresignedUpload.fromJson,
      ),
    );

    final _PresignedUpload? upload = response.data.firstOrNull;
    if (upload == null) return const [];

    final String? uploadUrl = upload.uploadUrl;
    if (uploadUrl != null && uploadUrl.isNotEmpty) {
      await _client.putBytes(
        Uri.parse(uploadUrl),
        bytes: bytes,
        contentType: contentType,
      );
    }

    final String? imageUrl = upload.imageUrl;
    return imageUrl == null || imageUrl.isEmpty ? const [] : [imageUrl];
  }
}

class _PresignedUpload {
  const _PresignedUpload({this.uploadUrl, this.imageUrl});

  factory _PresignedUpload.fromJson(JsonMap json) {
    return _PresignedUpload(
      uploadUrl: json['uploadUrl']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  final String? uploadUrl;
  final String? imageUrl;
}
