import '../data/models/requests/login_request.dart';
import '../data/models/requests/register_request.dart';
import '../../../core/user/current_user.dart';
import '../data/models/register_response.dart';

abstract class AuthRepository {
  Future<void> login(LoginRequest request);

  Future<RegisterResponse> register(RegisterRequest request);

  Future<CurrentUser> getProfile();

  Future<void> logout();
}
