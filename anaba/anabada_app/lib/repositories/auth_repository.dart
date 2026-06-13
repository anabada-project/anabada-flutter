import '../models/app_user.dart';

abstract class AuthRepository {
  AppUser? get currentUser;

  bool isEmailRegistered(String email);

  bool register({required AppUser user, required String password});

  AppUser? login({required String email, required String password});

  void logout();
}
