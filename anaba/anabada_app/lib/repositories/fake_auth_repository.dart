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
  void logout() {
    FakeData.currentUser = null;
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();
}
