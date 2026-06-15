import '../models/app_user.dart';

class FakeAccount {
  FakeAccount({required this.user, required this.password});

  AppUser user;
  String password;
}

class FakeData {
  FakeData._();

  static const String correctEmail = 's26010@gsm.hs.kr';
  static const String correctPassword = 'password123!';

  static final List<FakeAccount> accounts = [
    FakeAccount(
      user: const AppUser(
        id: 'fake-user-1',
        name: '테스트 사용자',
        email: correctEmail,
        major: '안드로이드',
        gender: '남자',
        generation: '10기',
      ),
      password: correctPassword,
    ),
    FakeAccount(
      user: const AppUser(
        id: 'admin-user-1',
        name: '관리자',
        email: 'admin@gsm.hs.kr',
        major: '운영팀',
        gender: '',
        generation: '',
        isAdmin: true,
      ),
      password: 'admin123!',
    ),
  ];

  static AppUser? currentUser;
}
