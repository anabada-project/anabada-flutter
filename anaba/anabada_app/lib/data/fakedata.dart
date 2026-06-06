import '../models/app_user.dart';

class FakeAccount {
  const FakeAccount({required this.user, required this.password});

  final AppUser user;
  final String password;
}

class FakeData {
  FakeData._();

  static const String correctEmail = 's26010@gsm.hs.kr';
  static const String correctPassword = 'password123!';

  static final List<FakeAccount> accounts = [
    const FakeAccount(
      user: AppUser(
        id: 'fake-user-1',
        name: '테스트 사용자',
        email: correctEmail,
        major: '안드로이드',
        gender: '남자',
        generation: '10기',
      ),
      password: correctPassword,
    ),
  ];

  static AppUser? currentUser;
}
