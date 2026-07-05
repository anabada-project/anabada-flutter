import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';

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

class AuthApiMessageResult {
  const AuthApiMessageResult({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final String? data;
}

class AuthApiLoginResult {
  const AuthApiLoginResult({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}

class AuthApiTokenResult {
  const AuthApiTokenResult({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresIn,
    required this.refreshTokenExpiresIn,
  });

  final String accessToken;
  final String refreshToken;
  final String accessTokenExpiresIn;
  final String refreshTokenExpiresIn;
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
  Future<AuthApiMessageResult> sendSignUpEmailCode({
    required String email,
  }) async {
    return _postMessage(
      path: '/api/auth/email/send',
      requestName: 'Signup email send',
      requestBody: {'email': email.trim()},
      fallbackMessage: _emailSendFallbackMessage,
    );
  }

  Future<AuthApiMessageResult> verifySignUpEmailCode({
    required String email,
    required String code,
  }) async {
    return _postMessage(
      path: '/api/auth/email/verify',
      requestName: 'Signup email verify',
      requestBody: {'email': email.trim(), 'code': code.trim()},
      fallbackMessage: _emailVerifyFallbackMessage,
    );
  }

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

    final bool success = body['success'] != false;
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
      throw AuthApiException(
        '\uB85C\uADF8\uC778 \uC751\uB2F5 \uB370\uC774\uD130\uAC00 \uC62C\uBC14\uB974\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.',
        statusCode: statusCode,
      );
    }

    final String? accessToken = rawData['accessToken'] as String?;
    final String? refreshToken = rawData['refreshToken'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw AuthApiException(
        '\uD1A0\uD070 \uC815\uBCF4\uB97C \uBC1B\uC744 \uC218 \uC5C6\uC2B5\uB2C8\uB2E4.',
        statusCode: statusCode,
      );
    }

    return AuthApiLoginResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> signOut({required String accessToken}) async {
    debugPrint('Signout API request start');
    debugPrint('Request URL: ${ApiClient.uri('/api/auth/signout')}');

    final http.Response response = await http.delete(
      ApiClient.uri('/api/auth/signout'),
      headers: ApiClient.authHeaders(accessToken),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('Signout response statusCode: $statusCode');
    debugPrint('Signout response body: $responseBody');

    if (statusCode >= 200 && statusCode < 300) {
      return;
    }

    if (statusCode >= 500) {
      throw AuthApiException(_serverErrorMessage, statusCode: statusCode);
    }

    final Map<String, dynamic> body = _decodeJsonObjectOrEmpty(responseBody);
    final String message =
        body['message']?.toString() ?? _signOutFallbackMessage(statusCode);

    throw AuthApiException(message, statusCode: statusCode);
  }

  Future<AuthApiTokenResult> reissueToken({
    required String refreshToken,
  }) async {
    debugPrint('Retoken API request start');
    debugPrint('Request URL: ${ApiClient.uri('/auth/retoken')}');

    final http.Response response = await http.post(
      ApiClient.uri('/auth/retoken'),
      headers: ApiClient.refreshHeaders(refreshToken),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('Retoken response statusCode: $statusCode');
    debugPrint('Retoken response body: $responseBody');

    if (statusCode >= 500) {
      throw AuthApiException(_serverErrorMessage, statusCode: statusCode);
    }

    final Map<String, dynamic> body = _decodeJsonObject(
      responseBody,
      statusCode: statusCode,
    );

    if (statusCode != 200) {
      final String message =
          body['message']?.toString() ?? _retokenFallbackMessage(statusCode);
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
      throw AuthApiException(
        '\uC7AC\uBC1C\uAE09\uB41C \uD1A0\uD070 \uC815\uBCF4\uB97C \uBC1B\uC744 \uC218 \uC5C6\uC2B5\uB2C8\uB2E4.',
        statusCode: statusCode,
      );
    }

    return AuthApiTokenResult(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      accessTokenExpiresIn: accessTokenExpiresIn ?? '',
      refreshTokenExpiresIn: refreshTokenExpiresIn ?? '',
    );
  }

  Future<AuthApiMessageResult> _postMessage({
    required String path,
    required String requestName,
    required Map<String, dynamic> requestBody,
    required String Function(int statusCode) fallbackMessage,
  }) async {
    debugPrint('$requestName API request start');
    debugPrint('Request URL: ${ApiClient.uri(path)}');

    final http.Response response = await http.post(
      ApiClient.uri(path),
      headers: ApiClient.jsonHeaders,
      body: jsonEncode(requestBody),
    );

    final int statusCode = response.statusCode;
    final String responseBody = utf8.decode(response.bodyBytes);

    debugPrint('$requestName response statusCode: $statusCode');
    debugPrint('$requestName response body: $responseBody');

    if (statusCode >= 500) {
      throw AuthApiException(_serverErrorMessage, statusCode: statusCode);
    }

    final Map<String, dynamic> body = _decodeJsonObject(
      responseBody,
      statusCode: statusCode,
    );

    if (statusCode != 200) {
      final String message =
          body['message']?.toString() ?? fallbackMessage(statusCode);
      throw AuthApiException(message, statusCode: statusCode);
    }

    final bool success = body['success'] != false;
    final String message =
        body['message']?.toString() ?? fallbackMessage(statusCode);

    if (!success) {
      throw AuthApiException(message, statusCode: statusCode);
    }

    return AuthApiMessageResult(
      success: success,
      message: message,
      data: body['data']?.toString(),
    );
  }

  static const String _serverErrorMessage =
      '\uC11C\uBC84 \uC624\uB958\uAC00 \uBC1C\uC0DD\uD588\uC2B5\uB2C8\uB2E4. \uC7A0\uC2DC \uD6C4 \uB2E4\uC2DC \uC2DC\uB3C4\uD574\uC8FC\uC138\uC694.';

  String _emailSendFallbackMessage(int statusCode) {
    return switch (statusCode) {
      200 =>
        '\uC778\uC99D\uBC88\uD638\uAC00 \uC815\uC0C1\uC801\uC73C\uB85C \uBC1C\uC1A1\uB418\uC5C8\uC2B5\uB2C8\uB2E4.',
      400 =>
        '\uC62C\uBC14\uB978 \uC774\uBA54\uC77C\uC744 \uC785\uB825\uD574\uC8FC\uC138\uC694.',
      409 =>
        '\uC774\uBBF8 \uAC00\uC785\uB41C \uC774\uBA54\uC77C\uC785\uB2C8\uB2E4.',
      429 =>
        '\uC778\uC99D\uBC88\uD638\uB97C \uB108\uBB34 \uB9CE\uC774 \uC694\uCCAD\uD588\uC2B5\uB2C8\uB2E4. \uC7A0\uC2DC \uD6C4 \uB2E4\uC2DC \uC2DC\uB3C4\uD574\uC8FC\uC138\uC694.',
      _ =>
        '\uC778\uC99D\uBC88\uD638 \uBC1C\uC1A1\uC5D0 \uC2E4\uD328\uD588\uC2B5\uB2C8\uB2E4.',
    };
  }

  String _emailVerifyFallbackMessage(int statusCode) {
    return switch (statusCode) {
      200 => '\uC778\uC99D\uC5D0 \uC131\uACF5\uD588\uC2B5\uB2C8\uB2E4.',
      400 =>
        '\uC778\uC99D\uBC88\uD638 \uD615\uC2DD\uC774 \uC62C\uBC14\uB974\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.',
      401 =>
        '\uC778\uC99D\uBC88\uD638\uAC00 \uC77C\uCE58\uD558\uC9C0 \uC54A\uAC70\uB098 \uB9CC\uB8CC\uB418\uC5C8\uC2B5\uB2C8\uB2E4.',
      429 =>
        '\uC778\uC99D \uC2DC\uB3C4 \uD69F\uC218\uAC00 \uB108\uBB34 \uB9CE\uC2B5\uB2C8\uB2E4. \uC7A0\uC2DC \uD6C4 \uB2E4\uC2DC \uC2DC\uB3C4\uD574\uC8FC\uC138\uC694.',
      _ =>
        '\uC774\uBA54\uC77C \uC778\uC99D\uC5D0 \uC2E4\uD328\uD588\uC2B5\uB2C8\uB2E4.',
    };
  }

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

  String _signOutFallbackMessage(int statusCode) {
    return switch (statusCode) {
      401 =>
        '\uC720\uD6A8\uD558\uC9C0 \uC54A\uAC70\uB098 \uB9CC\uB8CC\uB41C \uC561\uC138\uC2A4 \uD1A0\uD070\uC785\uB2C8\uB2E4.',
      403 =>
        '\uB85C\uADF8\uC544\uC6C3 \uAD8C\uD55C\uC774 \uC5C6\uC2B5\uB2C8\uB2E4.',
      _ =>
        '\uB85C\uADF8\uC544\uC6C3\uC5D0 \uC2E4\uD328\uD588\uC2B5\uB2C8\uB2E4.',
    };
  }

  String _retokenFallbackMessage(int statusCode) {
    return switch (statusCode) {
      401 =>
        '\uC720\uD6A8\uD558\uC9C0 \uC54A\uAC70\uB098 \uB9CC\uB8CC\uB41C \uB9AC\uD504\uB808\uC2DC \uD1A0\uD070\uC785\uB2C8\uB2E4.',
      403 =>
        '\uD1A0\uD070 \uC7AC\uBC1C\uAE09 \uAD8C\uD55C\uC774 \uC5C6\uC2B5\uB2C8\uB2E4.',
      _ =>
        '\uD1A0\uD070 \uC7AC\uBC1C\uAE09\uC5D0 \uC2E4\uD328\uD588\uC2B5\uB2C8\uB2E4.',
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
      return <String, dynamic>{};
    }

    try {
      final dynamic decodedBody = jsonDecode(responseBody);

      if (decodedBody is Map<String, dynamic>) {
        return decodedBody;
      }

      return <String, dynamic>{};
    } on FormatException {
      return <String, dynamic>{};
    }
  }
}
