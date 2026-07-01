import '../../../core/user/current_user.dart';

abstract interface class AuthRepository {
  Future<void> login({
    required String usernameOrEmail,
    required String password,
  });

  Future<void> logout();

  Future<CurrentUser> getProfile();
}
