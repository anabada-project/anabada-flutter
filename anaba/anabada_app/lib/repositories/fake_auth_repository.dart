import '../data/fakedata.dart';
import '../models/app_user.dart';
import 'auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  AppUser? get currentUser => FakeData.currentUser;

  @override
  bool isEmailRegistered(String email) {
    final normalizedEmail = _normalizeEmail(email);
    return FakeData.accounts.any(
      (account) => _normalizeEmail(account.user.email) == normalizedEmail,
    );
  }

  @override
  bool register({required AppUser user, required String password}) {
    if (isEmailRegistered(user.email)) {
      return false;
    }

    FakeData.accounts.add(FakeAccount(user: user, password: password));
    return true;
  }

  @override
  AppUser? login({required String email, required String password}) {
    final normalizedEmail = _normalizeEmail(email);

    for (final account in FakeData.accounts) {
      if (_normalizeEmail(account.user.email) == normalizedEmail &&
          account.password == password) {
        FakeData.currentUser = account.user;
        return account.user;
      }
    }

    return null;
  }

  @override
  AppUser? updateProfile({
    required String userId,
    required String name,
    required String major,
    required String generation,
  }) {
    for (final FakeAccount account in FakeData.accounts) {
      if (account.user.id == userId) {
        account.user = account.user.copyWith(
          name: name.trim(),
          major: major.trim(),
          generation: generation,
        );
        if (FakeData.currentUser?.id == userId) {
          FakeData.currentUser = account.user;
        }
        return account.user;
      }
    }
    return null;
  }

  @override
  bool resetPassword({required String email, required String newPassword}) {
    final String normalizedEmail = _normalizeEmail(email);
    for (final FakeAccount account in FakeData.accounts) {
      if (_normalizeEmail(account.user.email) == normalizedEmail) {
        account.password = newPassword;
        return true;
      }
    }
    return false;
  }

  @override
  void logout() {
    FakeData.currentUser = null;
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();
}
