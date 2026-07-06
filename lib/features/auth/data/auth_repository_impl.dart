import '../../../../core/storage/token_storage.dart';
import '../../../core/user/current_user.dart';
import '../domain/auth_repository.dart';
import 'auth_api_client.dart';
import 'models/requests/login_request.dart';
import 'models/requests/register_request.dart';
import 'models/register_response.dart';
import '../../../core/errors/failure_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._authApiClient, this._tokenStorage);

  final AuthApiClient _authApiClient;
  final TokenStorage _tokenStorage;

  @override
  Future<void> login(LoginRequest request) async {
    try {
      await _tokenStorage.clearTokens();

      final response = await _authApiClient.login(request);

      await _tokenStorage.saveAccessToken(response.accessToken);
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to login. Please try again.',
      );
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      return await _authApiClient.register(request);
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to register. Please try again.',
      );
    }
  }

  @override
  Future<CurrentUser> getProfile() async {
    try {
      return await _authApiClient.getProfile();
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to load your profile.',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _tokenStorage.clearTokens();
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to logout. Please try again.',
      );
    }
  }
}
