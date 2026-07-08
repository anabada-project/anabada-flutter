import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import 'auth_api_service.dart';

final AuthService authService = AuthService();

enum EmailVerificationPurpose { signUp, passwordReset }

class AuthService extends ChangeNotifier {
  AuthService({AuthApiService? authApiService})
    : _authApiService = authApiService ?? AuthApiService();

  final AuthApiService _authApiService;

  String? _accessToken;
  String? _refreshToken;
  AppUser? _apiCurrentUser;

  AppUser? get currentUser => _apiCurrentUser;

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  bool isEmailRegistered(String email) {
    return false;
  }

  bool signUp({
    required String name,
    required String email,
    required String password,
    required String major,
    required String gender,
    required String generation,
  }) {
    return false;
  }

  Future<AuthApiSignUpResult> signUpWithApi({
    required String name,
    required String id,
    required String email,
    required String password,
    required String specialism,
    required String gender,
    required String generation,
  }) {
    return _authApiService.signUp(
      name: name,
      id: id,
      email: email,
      password: password,
      specialism: specialism,
      gender: gender,
      generation: generation,
    );
  }

  Future<AuthApiMessageResult> requestSignUpEmailCodeWithApi({
    required String email,
  }) {
    return _authApiService.sendSignUpEmailCode(email: email);
  }

  Future<AuthApiMessageResult> verifySignUpEmailCodeWithApi({
    required String email,
    required String code,
  }) {
    return _authApiService.verifySignUpEmailCode(email: email, code: code);
  }

  AppUser? login({required String email, required String password}) {
    return null;
  }

  Future<AppUser?> loginWithApi({
    required String id,
    required String password,
  }) async {
    final AuthApiLoginResult result = await _authApiService.signIn(
      id: id,
      password: password,
    );

    _accessToken = result.accessToken;
    _refreshToken = result.refreshToken;

    _apiCurrentUser = AppUser(
      id: id.trim(),
      name: id.trim(),
      email: id.trim(),
      major: '',
      gender: '',
      generation: '',
    );

    notifyListeners();

    return _apiCurrentUser;
  }

  Future<bool> refreshTokenWithApi() async {
    final String? savedRefreshToken = _refreshToken;

    if (savedRefreshToken == null || savedRefreshToken.isEmpty) {
      logout();
      return false;
    }

    try {
      final AuthApiTokenResult result = await _authApiService.reissueToken(
        refreshToken: savedRefreshToken,
      );

      _accessToken = result.accessToken;
      _refreshToken = result.refreshToken;

      notifyListeners();

      return true;
    } on AuthApiException catch (error) {
      debugPrint('Token reissue failed: ${error.message}');

      if (error.statusCode == 401 || error.statusCode == 403) {
        logout();
      }

      return false;
    } catch (error) {
      debugPrint('Token reissue handling failed: $error');
      return false;
    }
  }

  Future<void> logoutWithApi() async {
    final String? savedAccessToken = _accessToken;

    try {
      if (savedAccessToken != null && savedAccessToken.isNotEmpty) {
        await _authApiService.signOut(accessToken: savedAccessToken);
      }
    } finally {
      logout();
    }
  }

  void logout() {
    _accessToken = null;
    _refreshToken = null;
    _apiCurrentUser = null;

    notifyListeners();
  }

  AppUser? updateProfile({
    required String name,
    required String major,
    required String generation,
  }) {
    final AppUser? user = currentUser;

    if (user == null) {
      return null;
    }

    _apiCurrentUser = user.copyWith(
      name: name,
      major: major,
      generation: generation,
    );

    notifyListeners();

    return _apiCurrentUser;
  }

  Future<AuthApiMessageResult> requestVerificationCode({
    required String email,
    required EmailVerificationPurpose purpose,
  }) {
    return _authApiService.sendEmailCode(email: email);
  }

  Future<AuthApiMessageResult> verifyCode({
    required String email,
    required String code,
  }) {
    return _authApiService.verifyEmailCode(email: email, code: code);
  }

  bool resetPassword({required String email, required String newPassword}) {
    return false;
  }
}
