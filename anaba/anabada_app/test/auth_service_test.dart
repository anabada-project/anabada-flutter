import 'package:anabada_app/repositories/fake_auth_repository.dart';
import 'package:anabada_app/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registered fake account can log in with saved profile data', () {
    final service = AuthService(FakeAuthRepository());
    final email = 'new-user-${DateTime.now().microsecondsSinceEpoch}@test.com';

    final didSignUp = service.signUp(
      name: '새 사용자',
      email: email,
      password: 'password123',
      major: '안드로이드',
      gender: '남자',
      generation: '10기',
    );

    expect(didSignUp, isTrue);

    final user = service.login(email: email, password: 'password123');

    expect(user, isNotNull);
    expect(user!.name, '새 사용자');
    expect(user.major, '안드로이드');
    expect(user.gender, '남자');
    expect(user.generation, '10기');
    expect(service.currentUser, same(user));
  });

  test('duplicate email cannot be registered twice', () {
    final service = AuthService(FakeAuthRepository());
    final email = 'duplicate-${DateTime.now().microsecondsSinceEpoch}@test.com';

    final firstResult = service.signUp(
      name: '첫 사용자',
      email: email,
      password: 'password123',
      major: 'iOS',
      gender: '여자',
      generation: '9기',
    );
    final secondResult = service.signUp(
      name: '두 번째 사용자',
      email: email.toUpperCase(),
      password: 'password456',
      major: 'AI',
      gender: '남자',
      generation: '10기',
    );

    expect(firstResult, isTrue);
    expect(secondResult, isFalse);
  });

  test('profile and password changes are stored in the repository', () {
    final service = AuthService(FakeAuthRepository());
    final email = 'profile-${DateTime.now().microsecondsSinceEpoch}@test.com';

    service.signUp(
      name: '변경 전',
      email: email,
      password: 'password123',
      major: '플러터',
      gender: '여자',
      generation: '9기',
    );
    service.login(email: email, password: 'password123');

    final updated = service.updateProfile(
      name: '변경 후',
      major: '백엔드',
      generation: '10기',
    );
    expect(updated?.name, '변경 후');
    expect(service.currentUser?.major, '백엔드');

    expect(
      service.resetPassword(email: email, newPassword: 'newPassword123'),
      isTrue,
    );
    service.logout();
    expect(
      service.login(email: email, password: 'newPassword123'),
      isNotNull,
    );
  });
}
