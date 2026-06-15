import 'dart:convert';

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
    final http.Response response = await http.post(
      ApiClient.uri('/api/auth/signin'),
      headers: ApiClient.jsonHeaders,
      body: jsonEncode({'id': id.trim(), 'password': password}),
    );

    final Map<String, dynamic> body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      final String message = body['message']?.toString() ?? '로그인에 실패했습니다.';
      throw AuthApiException(message);
    }

    if (response.statusCode != 200) {
      throw const AuthApiException('서버 오류가 발생했습니다.');
    }

    final Map<String, dynamic>? data = body['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw const AuthApiException('로그인 응답 데이터가 없습니다.');
    }

    final String? accessToken = data['accessToken'] as String?;
    final String? refreshToken = data['refreshToken'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw const AuthApiException('토큰 정보를 받을 수 없습니다.');
    }

    return AuthApiLoginResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
