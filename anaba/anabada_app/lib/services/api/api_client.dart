import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'api_request.dart';
import 'api_response.dart';

typedef TokenProvider = FutureOr<String?> Function();

class ApiClient {
  ApiClient({
    String baseUrl = defaultBaseUrl,
    http.Client? httpClient,
    this.tokenProvider,
  }) : _baseUri = Uri.parse(_normalizeBaseUrl(baseUrl)),
       _httpClient = httpClient ?? http.Client();

  static const String defaultBaseUrl = 'https://anabada.shop:22124/';

  final Uri _baseUri;
  final http.Client _httpClient;
  final TokenProvider? tokenProvider;

  Future<dynamic> get(
    String path, {
    Map<String, String?> queryParameters = const {},
    bool authenticated = true,
  }) {
    return send(
      ApiRequest.get(
        path,
        queryParameters: queryParameters,
        authenticated: authenticated,
      ),
    );
  }

  Future<dynamic> post(String path, {Object? body, bool authenticated = true}) {
    return send(
      ApiRequest.post(path, body: body, authenticated: authenticated),
    );
  }

  Future<dynamic> put(String path, {Object? body, bool authenticated = true}) {
    return send(ApiRequest.put(path, body: body, authenticated: authenticated));
  }

  Future<dynamic> patch(
    String path, {
    Object? body,
    bool authenticated = true,
  }) {
    return send(
      ApiRequest.patch(path, body: body, authenticated: authenticated),
    );
  }

  Future<dynamic> delete(String path, {bool authenticated = true}) {
    return send(ApiRequest.delete(path, authenticated: authenticated));
  }

  Future<ApiResponse<T>> getResponse<T>(
    String path, {
    required ApiResponseParser<T> parser,
    Map<String, String?> queryParameters = const {},
    bool authenticated = true,
  }) {
    return sendResponse<T>(
      ApiRequest.get(
        path,
        queryParameters: queryParameters,
        authenticated: authenticated,
      ),
      parser: parser,
    );
  }

  Future<ApiResponse<T>> postResponse<T>(
    String path, {
    required ApiResponseParser<T> parser,
    Object? body,
    bool authenticated = true,
  }) {
    return sendResponse<T>(
      ApiRequest.post(path, body: body, authenticated: authenticated),
      parser: parser,
    );
  }

  Future<ApiResponse<T>> putResponse<T>(
    String path, {
    required ApiResponseParser<T> parser,
    Object? body,
    bool authenticated = true,
  }) {
    return sendResponse<T>(
      ApiRequest.put(path, body: body, authenticated: authenticated),
      parser: parser,
    );
  }

  Future<ApiResponse<T>> patchResponse<T>(
    String path, {
    required ApiResponseParser<T> parser,
    Object? body,
    bool authenticated = true,
  }) {
    return sendResponse<T>(
      ApiRequest.patch(path, body: body, authenticated: authenticated),
      parser: parser,
    );
  }

  Future<dynamic> send(ApiRequest request) {
    return _send(request);
  }

  Future<ApiResponse<T>> sendResponse<T>(
    ApiRequest request, {
    required ApiResponseParser<T> parser,
  }) async {
    final dynamic response = await send(request);
    return ApiResponse<T>.fromRaw(response, parser: parser);
  }

  Future<void> putBytes(
    Uri uploadUrl, {
    required Uint8List bytes,
    required String contentType,
  }) async {
    final http.Response response = await _httpClient.put(
      uploadUrl,
      headers: {'Content-Type': contentType},
      body: bytes,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: '이미지 업로드에 실패했습니다.',
        body: _decodeBody(response.body),
      );
    }
  }

  Future<dynamic> _send(ApiRequest request) async {
    final Uri uri = _uri(request.path, request.queryParameters);
    final Map<String, String> headers = {'Accept': 'application/json'};

    if (request.body != null) {
      headers['Content-Type'] = 'application/json';
    }

    final String? token = await tokenProvider?.call();
    if (request.authenticated && token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    final String? encodedBody = request.body == null
        ? null
        : jsonEncode(request.body);
    final http.Response response = switch (request.method) {
      'GET' => await _httpClient.get(uri, headers: headers),
      'POST' => await _httpClient.post(
        uri,
        headers: headers,
        body: encodedBody,
      ),
      'PUT' => await _httpClient.put(uri, headers: headers, body: encodedBody),
      'PATCH' => await _httpClient.patch(
        uri,
        headers: headers,
        body: encodedBody,
      ),
      'DELETE' => await _httpClient.delete(uri, headers: headers),
      _ => throw ArgumentError.value(
        request.method,
        'method',
        '지원하지 않는 method',
      ),
    };

    final dynamic decodedBody = _decodeBody(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: _messageFrom(decodedBody) ?? '요청에 실패했습니다.',
        body: decodedBody,
      );
    }

    if (decodedBody is Map<String, dynamic> &&
        decodedBody['success'] == false) {
      throw ApiException(
        statusCode: response.statusCode,
        message: _messageFrom(decodedBody) ?? '요청에 실패했습니다.',
        body: decodedBody,
      );
    }

    return decodedBody;
  }

  Uri _uri(String path, Map<String, String?> queryParameters) {
    final String normalizedPath = path.startsWith('/')
        ? path.substring(1)
        : path;
    final Uri resolved = _baseUri.resolve(normalizedPath);
    final Map<String, String> mergedQuery = {...resolved.queryParameters};

    for (final MapEntry<String, String?> entry in queryParameters.entries) {
      final String? value = entry.value;
      if (value != null) {
        mergedQuery[entry.key] = value;
      }
    }

    return resolved.replace(
      queryParameters: mergedQuery.isEmpty ? null : mergedQuery,
    );
  }

  static String _normalizeBaseUrl(String baseUrl) {
    return baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
  }

  static dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) return null;

    try {
      return jsonDecode(body) as dynamic;
    } catch (_) {
      return body;
    }
  }

  static String? _messageFrom(dynamic body) {
    if (body is Map<String, dynamic>) {
      final Object? message = body['message'] ?? body['error'];
      return message?.toString();
    }
    return null;
  }
}

class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.body,
  });

  final int? statusCode;
  final String message;
  final Object? body;

  @override
  String toString() {
    final int? code = statusCode;
    if (code == null) return message;
    return '$message ($code)';
  }
}
