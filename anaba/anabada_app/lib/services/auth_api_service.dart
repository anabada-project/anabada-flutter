import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class AuthApiLoginResult {
  final String accessToken;
  final String refreshToken;

  const AuthApiLoginResult({
    required this.accessToken,
    required this.refreshToken,
  });
}

class AuthApiTokenResult {
  final String accessToken;
  final String refreshToken;
  final String accessTokenExpiresIn;
  final String refreshTokenExpiresIn;

  const AuthApiTokenResult({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresIn,
    required this.refreshTokenExpiresIn,
  });
}

class AuthApiException implements Exception {
  final String message;
  final int? statusCode;

  const AuthApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return message;
  }
}

class AuthApiService {
  Future<AuthApiLoginResult> signIn({
    required String id,
    required String password,
  }) async {
    debugPrint('로그인 API 요청 시작');
    debugPrint('요청 주소: ${ApiClient.uri('/api/auth/signin')}');
    debugPrint('요청 id: $id');

    final http.Response response = await http.post(
      ApiClient.uri('/api/auth/signin'),
      headers: ApiClient.jsonHeaders,
      body: jsonEncode({'id': id.trim(), 'password': password}),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('응답 statusCode: $statusCode');
    debugPrint('응답 body: $responseBody');

    if (statusCode >= 500) {
      throw AuthApiException(
        '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
        statusCode: statusCode,
      );
    }

    final Map<String, dynamic> body = _decodeJsonObject(responseBody);

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      final String message = body['message']?.toString() ?? '로그인에 실패했습니다.';
      throw AuthApiException(message, statusCode: statusCode);
    }

    if (statusCode != 200) {
      final String message = body['message']?.toString() ?? '로그인 요청에 실패했습니다.';
      throw AuthApiException(message, statusCode: statusCode);
    }

    final dynamic rawData = body['data'];

    if (rawData is! Map<String, dynamic>) {
      throw const AuthApiException('로그인 응답 데이터가 올바르지 않습니다.');
    }

    final String? accessToken = rawData['accessToken'] as String?;
    final String? refreshToken = rawData['refreshToken'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw const AuthApiException('토큰 정보를 받을 수 없습니다.');
    }

    return AuthApiLoginResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> signOut({required String accessToken}) async {
    debugPrint('로그아웃 API 요청 시작');
    debugPrint('요청 주소: ${ApiClient.uri('/api/auth/signout')}');

    final http.Response response = await http.delete(
      ApiClient.uri('/api/auth/signout'),
      headers: ApiClient.authHeaders(accessToken),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('응답 statusCode: $statusCode');
    debugPrint('응답 body: $responseBody');

    if (statusCode >= 200 && statusCode < 300) {
      return;
    }

    if (statusCode >= 500) {
      throw AuthApiException(
        '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
        statusCode: statusCode,
      );
    }

    final Map<String, dynamic> body = _decodeJsonObjectOrEmpty(responseBody);

    if (statusCode == 401) {
      final String message =
          body['message']?.toString() ?? '유효하지 않거나 만료된 액세스 토큰입니다.';
      throw AuthApiException(message, statusCode: statusCode);
    }

    if (statusCode == 403) {
      final String message = body['message']?.toString() ?? '접근 권한이 없습니다.';
      throw AuthApiException(message, statusCode: statusCode);
    }

    final String message = body['message']?.toString() ?? '로그아웃에 실패했습니다.';
    throw AuthApiException(message, statusCode: statusCode);
  }

  Future<AuthApiTokenResult> reissueToken({
    required String refreshToken,
  }) async {
    debugPrint('토큰 재발급 API 요청 시작');
    debugPrint('요청 주소: ${ApiClient.uri('/auth/retoken')}');

    final http.Response response = await http.post(
      ApiClient.uri('/auth/retoken'),
      headers: ApiClient.refreshHeaders(refreshToken),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('응답 statusCode: $statusCode');
    debugPrint('응답 body: $responseBody');

    if (statusCode >= 500) {
      throw AuthApiException(
        '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
        statusCode: statusCode,
      );
    }

    final Map<String, dynamic> body = _decodeJsonObjectOrEmpty(responseBody);

    if (statusCode == 401) {
      final String message =
          body['message']?.toString() ?? '유효하지 않거나 만료된 리프레시 토큰입니다.';
      throw AuthApiException(message, statusCode: statusCode);
    }

    if (statusCode == 403) {
      final String message = body['message']?.toString() ?? '토큰 재발급 권한이 없습니다.';
      throw AuthApiException(message, statusCode: statusCode);
    }

    if (statusCode != 200) {
      final String message = body['message']?.toString() ?? '토큰 재발급에 실패했습니다.';
      throw AuthApiException(message, statusCode: statusCode);
    }

    final dynamic rawData = body['data'];

    final Map<String, dynamic> tokenBody = rawData is Map<String, dynamic>
        ? rawData
        : body;

    final String? newAccessToken = tokenBody['accessToken'] as String?;
    final String? newRefreshToken = tokenBody['refreshToken'] as String?;
    final String? accessTokenExpiresIn =
        tokenBody['accessTokenExpiresIn'] as String?;
    final String? refreshTokenExpiresIn =
        tokenBody['refreshTokenExpiresIn'] as String?;

    if (newAccessToken == null || newRefreshToken == null) {
      throw const AuthApiException('재발급된 토큰 정보를 받을 수 없습니다.');
    }

    return AuthApiTokenResult(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      accessTokenExpiresIn: accessTokenExpiresIn ?? '',
      refreshTokenExpiresIn: refreshTokenExpiresIn ?? '',
    );
  }

  Map<String, dynamic> _decodeJsonObject(String responseBody) {
    try {
      final dynamic decodedBody = jsonDecode(responseBody);

      if (decodedBody is Map<String, dynamic>) {
        return decodedBody;
      }

      throw const AuthApiException('서버 응답 형식이 올바르지 않습니다.');
    } on FormatException {
      throw const AuthApiException('서버 응답을 읽을 수 없습니다.');
    }
  }

  Map<String, dynamic> _decodeJsonObjectOrEmpty(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return {};
    }

    try {
      final dynamic decodedBody = jsonDecode(responseBody);

      if (decodedBody is Map<String, dynamic>) {
        return decodedBody;
      }

      return {};
    } on FormatException {
      return {};
    }
  }
}
