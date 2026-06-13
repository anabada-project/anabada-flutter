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
}
