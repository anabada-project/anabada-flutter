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

class AuthApiException implements Exception {
  final String message;

  const AuthApiException(this.message);

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
      throw const AuthApiException('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }

    final Map<String, dynamic> body = _decodeJsonObject(responseBody);

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      final String message = body['message']?.toString() ?? '로그인에 실패했습니다.';
      throw AuthApiException(message);
    }

    if (statusCode != 200) {
      final String message = body['message']?.toString() ?? '로그인 요청에 실패했습니다.';
      throw AuthApiException(message);
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

  Future<void> sendSignUpEmailCode({required String email}) async {
    debugPrint('회원가입 인증번호 발송 API 요청 시작');
    debugPrint('요청 주소: ${ApiClient.uri('/api/auth/email/send')}');

    final http.Response response = await http.post(
      ApiClient.uri('/api/auth/email/send'),
      headers: ApiClient.jsonHeaders,
      body: jsonEncode({'email': email.trim()}),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('응답 statusCode: $statusCode');
    debugPrint('응답 body: $responseBody');

    if (statusCode >= 500) {
      throw const AuthApiException('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }

    final Map<String, dynamic> body = _decodeJsonObject(responseBody);

    if (statusCode == 409) {
      final String message = body['message']?.toString() ?? '이미 가입된 이메일입니다.';
      throw AuthApiException(message);
    }

    if (statusCode == 429) {
      final String message =
          body['message']?.toString() ?? '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
      throw AuthApiException(message);
    }

    if (statusCode != 200) {
      final String message = body['message']?.toString() ?? '인증번호 발송에 실패했습니다.';
      throw AuthApiException(message);
    }
  }

  Future<void> verifySignUpEmailCode({
    required String email,
    required String code,
  }) async {
    debugPrint('회원가입 인증번호 확인 API 요청 시작');
    debugPrint('요청 주소: ${ApiClient.uri('/api/auth/email/verify')}');

    final http.Response response = await http.post(
      ApiClient.uri('/api/auth/email/verify'),
      headers: ApiClient.jsonHeaders,
      body: jsonEncode({'email': email.trim(), 'code': code.trim()}),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('응답 statusCode: $statusCode');
    debugPrint('응답 body: $responseBody');

    if (statusCode >= 500) {
      throw const AuthApiException('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }

    final Map<String, dynamic> body = _decodeJsonObject(responseBody);

    if (statusCode == 401) {
      final String message = body['message']?.toString() ?? '인증코드가 올바르지 않습니다.';
      throw AuthApiException(message);
    }

    if (statusCode == 429) {
      final String message =
          body['message']?.toString() ?? '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
      throw AuthApiException(message);
    }

    if (statusCode != 200) {
      final String message = body['message']?.toString() ?? '인증번호 확인에 실패했습니다.';
      throw AuthApiException(message);
    }
  }

  Future<void> signUp({
    required String name,
    required String id,
    required String email,
    required String password,
    required String gender,
    required String specialism,
    required String generation,
  }) async {
    debugPrint('회원가입 API 요청 시작');
    debugPrint('요청 주소: ${ApiClient.uri('/auth/signup')}');
    debugPrint('요청 id: $id');
    debugPrint('요청 email: $email');

    final http.Response response = await http.post(
      ApiClient.uri('/auth/signup'),
      headers: ApiClient.jsonHeaders,
      body: jsonEncode({
        'name': name.trim(),
        'id': id.trim(),
        'email': email.trim(),
        'password': password,
        'gender': gender,
        'specialism': specialism,
        'generation': generation,
      }),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('응답 statusCode: $statusCode');
    debugPrint('응답 body: $responseBody');

    if (statusCode >= 500) {
      throw const AuthApiException('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }

    final Map<String, dynamic> body = _decodeJsonObject(responseBody);

    if (statusCode == 409) {
      final String message = body['message']?.toString() ?? '이미 가입된 정보가 있습니다.';
      throw AuthApiException(message);
    }

    if (statusCode != 201) {
      final String message = body['message']?.toString() ?? '회원가입에 실패했습니다.';
      throw AuthApiException(message);
    }
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
}
