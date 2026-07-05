import 'package:anabada_app/services/auth_api_service.dart';
import 'package:anabada_app/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubAuthApiService extends AuthApiService {
  @override
  Future<AuthApiLoginResult> signIn({
    required String id,
    required String password,
  }) async {
    return const AuthApiLoginResult(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
  }

  @override
  Future<void> signOut({required String accessToken}) async {}
}

void main() {
  test('API login stores current user and tokens', () async {
    final AuthService service = AuthService(
      authApiService: _StubAuthApiService(),
    );

    final user = await service.loginWithApi(
      id: 'user-id',
      password: 'password',
    );

    expect(user, isNotNull);
    expect(user!.id, 'user-id');
    expect(service.currentUser, same(user));
    expect(service.accessToken, 'access-token');
    expect(service.refreshToken, 'refresh-token');
  });

  test('logout clears API session state', () async {
    final AuthService service = AuthService(
      authApiService: _StubAuthApiService(),
    );

    await service.loginWithApi(id: 'user-id', password: 'password');
    await service.logoutWithApi();

    expect(service.currentUser, isNull);
    expect(service.accessToken, isNull);
    expect(service.refreshToken, isNull);
  });

  test('local auth methods do not create users without API', () {
    final AuthService service = AuthService(
      authApiService: _StubAuthApiService(),
    );

    expect(
      service.signUp(
        name: 'User',
        email: 'user@example.com',
        password: 'password',
        major: 'Backend',
        gender: 'MALE',
        generation: '10',
      ),
      isFalse,
    );
    expect(
      service.login(email: 'user@example.com', password: 'password'),
      isNull,
    );
    expect(
      service.resetPassword(
        email: 'user@example.com',
        newPassword: 'newPassword',
      ),
      isFalse,
    );
  });
}
