import '../domain/profile_repository.dart';
import 'models/change_password_request.dart';
import 'models/current_user_profile.dart';
import 'models/update_profile_request.dart';
import 'profile_api_client.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._apiClient);

  final ProfileApiClient _apiClient;

  @override
  Future<CurrentUserProfile> getProfile() {
    return _apiClient.getProfile();
  }

  @override
  Future<CurrentUserProfile> updateProfile(UpdateProfileRequest request) {
    return _apiClient.updateProfile(request);
  }

  @override
  Future<void> changePassword(ChangePasswordRequest request) {
    return _apiClient.changePassword(request);
  }
}
