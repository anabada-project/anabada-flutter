import '../models/app_user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/fake_auth_repository.dart';

final AuthService authService = AuthService(FakeAuthRepository());

class AuthService {
  AuthService(this._repository);

  final AuthRepository _repository;

  AppUser? get currentUser => _repository.currentUser;

  bool isEmailRegistered(String email) {
    return _repository.isEmailRegistered(email);
  }

  bool signUp({
    required String name,
    required String email,
    required String password,
    required String major,
    required String gender,
    required String generation,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final user = AppUser(
      id: 'fake-user-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      email: normalizedEmail,
      major: major,
      gender: gender,
      generation: generation,
    );

    return _repository.register(user: user, password: password);
  }

  AppUser? login({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }

  void logout() {
    _repository.logout();
  }
}
