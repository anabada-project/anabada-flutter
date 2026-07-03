import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class AuthApiLoginResult {
  const AuthApiLoginResult({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}

class AuthApiSignUpResult {
  const AuthApiSignUpResult({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final String? data;
}

class AuthApiException implements Exception {
  const AuthApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() {
    return message;
  }
}

class AuthApiService {
  Future<AuthApiSignUpResult> signUp({
    required String name,
    required String id,
    required String email,
    required String password,
    required String gender,
    required String specialism,
    required String generation,
  }) async {
    debugPrint('Signup API request start');
    debugPrint('Request URL: ${ApiClient.uri('/api/auth/signup')}');
    debugPrint('Request id: $id');

    final http.Response response = await http.post(
      ApiClient.uri('/api/auth/signup'),
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

    debugPrint('Signup response statusCode: $statusCode');
    debugPrint('Signup response body: $responseBody');

    if (statusCode >= 500) {
      throw AuthApiException(_serverErrorMessage, statusCode: statusCode);
    }

    final Map<String, dynamic> body = _decodeJsonObject(
      responseBody,
      statusCode: statusCode,
    );

    if (statusCode != 201) {
      final String message =
          body['message']?.toString() ?? _signUpFallbackMessage(statusCode);
      throw AuthApiException(message, statusCode: statusCode);
    }

    final bool success = body['success'] as bool? ?? true;
    final String message =
        body['message']?.toString() ??
        '\uD68C\uC6D0\uAC00\uC785\uC774 \uC644\uB8CC\uB418\uC5C8\uC2B5\uB2C8\uB2E4.';

    if (!success) {
      throw AuthApiException(message, statusCode: statusCode);
    }

    return AuthApiSignUpResult(
      success: success,
      message: message,
      data: body['data']?.toString(),
    );
  }

  Future<AuthApiLoginResult> signIn({
    required String id,
    required String password,
  }) async {
    debugPrint('Signin API request start');
    debugPrint('Request URL: ${ApiClient.uri('/api/auth/signin')}');
    debugPrint('Request id: $id');

    final http.Response response = await http.post(
      ApiClient.uri('/api/auth/signin'),
      headers: ApiClient.jsonHeaders,
      body: jsonEncode({'id': id.trim(), 'password': password}),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('Signin response statusCode: $statusCode');
    debugPrint('Signin response body: $responseBody');

    if (statusCode >= 500) {
      throw AuthApiException(_serverErrorMessage, statusCode: statusCode);
    }

    final Map<String, dynamic> body = _decodeJsonObject(
      responseBody,
      statusCode: statusCode,
    );

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      final String message =
          body['message']?.toString() ??
          '\uB85C\uADF8\uC778\uC5D0 \uC2E4\uD328\uD588\uC2B5\uB2C8\uB2E4.';
      throw AuthApiException(message, statusCode: statusCode);
    }

    if (statusCode != 200) {
      final String message =
          body['message']?.toString() ??
          '\uB85C\uADF8\uC778 \uC694\uCCAD\uC5D0 \uC2E4\uD328\uD588\uC2B5\uB2C8\uB2E4.';
      throw AuthApiException(message, statusCode: statusCode);
    }

    final dynamic rawData = body['data'];

    if (rawData is! Map<String, dynamic>) {
      throw const AuthApiException(
        '\uB85C\uADF8\uC778 \uC751\uB2F5 \uB370\uC774\uD130\uAC00 \uC62C\uBC14\uB974\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.',
      );
    }

    final String? accessToken = rawData['accessToken'] as String?;
    final String? refreshToken = rawData['refreshToken'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw const AuthApiException(
        '\uD1A0\uD070 \uC815\uBCF4\uB97C \uBC1B\uC744 \uC218 \uC5C6\uC2B5\uB2C8\uB2E4.',
      );
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
      throw const AuthApiException('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }

    final Map<String, dynamic> body = _decodeJsonObjectOrEmpty(responseBody);

    if (statusCode == 401) {
      final String message =
          body['message']?.toString() ?? '유효하지 않거나 만료된 액세스 토큰입니다.';
      throw AuthApiException(message);
    }

    if (statusCode == 403) {
      final String message = body['message']?.toString() ?? '접근 권한이 없습니다.';
      throw AuthApiException(message);
    }

    final String message = body['message']?.toString() ?? '로그아웃에 실패했습니다.';
    throw AuthApiException(message);
  }

  Map<String, dynamic> _decodeJsonObject(String responseBody) {
  static const String _serverErrorMessage =
      '\uC11C\uBC84 \uC624\uB958\uAC00 \uBC1C\uC0DD\uD588\uC2B5\uB2C8\uB2E4. \uC7A0\uC2DC \uD6C4 \uB2E4\uC2DC \uC2DC\uB3C4\uD574\uC8FC\uC138\uC694.';

  String _signUpFallbackMessage(int statusCode) {
    return switch (statusCode) {
      400 =>
        '\uD544\uC218 \uD56D\uBAA9\uC774 \uB204\uB77D\uB418\uC5C8\uAC70\uB098 \uD615\uC2DD\uC774 \uC62C\uBC14\uB974\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.',
      401 =>
        '\uC778\uC99D \uCF54\uB4DC\uAC00 \uC720\uD6A8\uD558\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.',
      409 =>
        '\uC774\uBBF8 \uC0AC\uC6A9 \uC911\uC778 \uC815\uBCF4\uAC00 \uC788\uC2B5\uB2C8\uB2E4.',
      _ =>
        '\uD68C\uC6D0\uAC00\uC785 \uC694\uCCAD\uC5D0 \uC2E4\uD328\uD588\uC2B5\uB2C8\uB2E4.',
    };
  }

  Map<String, dynamic> _decodeJsonObject(
    String responseBody, {
    int? statusCode,
  }) {
    if (responseBody.trim().isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final dynamic decodedBody = jsonDecode(responseBody);

      if (decodedBody is Map<String, dynamic>) {
        return decodedBody;
      }

      throw AuthApiException(
        '\uC11C\uBC84 \uC751\uB2F5 \uD615\uC2DD\uC774 \uC62C\uBC14\uB974\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.',
        statusCode: statusCode,
      );
    } on FormatException {
      throw AuthApiException(
        '\uC11C\uBC84 \uC751\uB2F5\uC744 \uC77D\uC744 \uC218 \uC5C6\uC2B5\uB2C8\uB2E4.',
        statusCode: statusCode,
      );
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
