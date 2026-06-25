abstract class AuthRepository {
  Future<void> login({
    required String usernameOrEmail,
    required String password,
  });

    Future<void> logout();
}