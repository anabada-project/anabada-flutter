import '../models/app_user.dart';

abstract class AuthRepository {
  AppUser? get currentUser;

  bool isEmailRegistered(String email);

  bool register({required AppUser user, required String password});

  AppUser? login({required String email, required String password});

  AppUser? updateProfile({
    required String userId,
    required String name,
    required String major,
    required String generation,
  });

  bool resetPassword({required String email, required String newPassword});

  void logout();
}
