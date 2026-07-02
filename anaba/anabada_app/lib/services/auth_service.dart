import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/fake_auth_repository.dart';
import 'auth_api_service.dart';

final AuthService authService = AuthService(FakeAuthRepository());

enum EmailVerificationPurpose { signUp, passwordReset }

class AuthService extends ChangeNotifier {
  AuthService(this._repository);

  final AuthRepository _repository;
  final AuthApiService _authApiService = AuthApiService();

  final Map<String, String> _verificationCodes = {};

  String? _accessToken;
  String? _refreshToken;
  AppUser? _apiCurrentUser;

  static const String localVerificationCode = '123456';

  AppUser? get currentUser => _apiCurrentUser ?? _repository.currentUser;

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  bool isEmailRegistered(String email) {
    return _repository.isEmailRegistered(email);
  }

  bool signUp({
    required String name,
    String? id,
    required String email,
    required String password,
    required String major,
    required String gender,
    required String generation,
  }) {
    final String normalizedEmail = email.trim().toLowerCase();

    final AppUser user = AppUser(
      id: id?.trim().isNotEmpty == true
          ? id!.trim()
          : 'fake-user-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      email: normalizedEmail,
      major: major,
      gender: gender,
      generation: generation,
    );

    final bool didRegister = _repository.register(
      user: user,
      password: password,
    );

    if (didRegister) {
      notifyListeners();
    }

    return didRegister;
  }

  AppUser? login({required String email, required String password}) {
    final AppUser? user = _repository.login(email: email, password: password);

    if (user != null) {
      notifyListeners();
    }

    return user;
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

  void logout() {
    _repository.logout();

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

    if (_apiCurrentUser != null) {
      _apiCurrentUser = _apiCurrentUser!.copyWith(
        name: name,
        major: major,
        generation: generation,
      );

      notifyListeners();

      return _apiCurrentUser;
    }

    final AppUser? updatedUser = _repository.updateProfile(
      userId: user.id,
      name: name,
      major: major,
      generation: generation,
    );

    if (updatedUser != null) {
      notifyListeners();
    }

    return updatedUser;
  }

  String? requestVerificationCode({
    required String email,
    required EmailVerificationPurpose purpose,
  }) {
    final String normalizedEmail = email.trim().toLowerCase();

    if (!_isValidEmail(normalizedEmail)) {
      return null;
    }

    final bool isRegistered = isEmailRegistered(normalizedEmail);

    if (purpose == EmailVerificationPurpose.signUp && isRegistered) {
      return null;
    }

    if (purpose == EmailVerificationPurpose.passwordReset && !isRegistered) {
      return null;
    }

    _verificationCodes[normalizedEmail] = localVerificationCode;

    return localVerificationCode;
  }

  bool verifyCode({required String email, required String code}) {
    final String normalizedEmail = email.trim().toLowerCase();

    return _verificationCodes[normalizedEmail] == code.trim();
  }

  bool resetPassword({required String email, required String newPassword}) {
    final bool didReset = _repository.resetPassword(
      email: email,
      newPassword: newPassword,
    );

    if (didReset) {
      _verificationCodes.remove(email.trim().toLowerCase());
    }

    return didReset;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}
