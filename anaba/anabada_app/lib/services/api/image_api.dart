import 'dart:typed_data';

import 'api_client.dart';
import 'api_response.dart';

class ImageApi {
  const ImageApi(this._client);

  final ApiClient _client;

  Future<ApiResponse<UploadedImage>> upload({
    required String filename,
    required Uint8List bytes,
  }) {
    return _client.postMultipartResponse<UploadedImage>(
      '/api/image',
      files: [
        ApiMultipartFile(fieldName: 'file', filename: filename, bytes: bytes),
      ],
      parser: (response) =>
          ApiResponse.parseData(response, UploadedImage.fromJson),
    );
  }
}

class UploadedImage {
  const UploadedImage({this.imageId, required this.imageUrl});

  factory UploadedImage.fromJson(JsonMap json) {
    return UploadedImage(
      imageId: _intValue(json['imageId'] ?? json['id']),
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  final int? imageId;
  final String imageUrl;

  static int? _intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
