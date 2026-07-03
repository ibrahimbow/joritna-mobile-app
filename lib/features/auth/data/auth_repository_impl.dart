import '../../../../core/storage/token_storage.dart';
import '../../../core/user/current_user.dart';
import '../domain/auth_repository.dart';
import 'auth_api_client.dart';
import 'models/requests/login_request.dart';
import 'models/requests/register_request.dart';
import 'models/register_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._authApiClient, this._tokenStorage);

  final AuthApiClient _authApiClient;
  final TokenStorage _tokenStorage;

  @override
  Future<void> login(LoginRequest request) async {
    await _tokenStorage.clearTokens();

    final response = await _authApiClient.login(request);

    await _tokenStorage.saveAccessToken(response.accessToken);
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) {
    return _authApiClient.register(request);
  }

  @override
  Future<CurrentUser> getProfile() {
    return _authApiClient.getProfile();
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}
