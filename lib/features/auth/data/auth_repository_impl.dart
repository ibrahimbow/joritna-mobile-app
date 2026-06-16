import '../domain/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';

import 'auth_api_client.dart';
import 'models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._authApiClient,
    this._tokenStorage,
  );

  final AuthApiClient _authApiClient;
  final TokenStorage _tokenStorage;

  @override
  Future<void> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final response = await _authApiClient.login(
      LoginRequest(
        usernameOrEmail: usernameOrEmail,
        password: password,
      ),
    );

    await _tokenStorage.saveAccessToken(
      response.accessToken,
    );
  }
}