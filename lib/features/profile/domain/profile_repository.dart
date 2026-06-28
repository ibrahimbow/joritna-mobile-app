import '../data/models/change_password_request.dart';
import '../data/models/current_user_profile.dart';
import '../data/models/update_profile_request.dart';

abstract class ProfileRepository {
  Future<CurrentUserProfile> getProfile();

  Future<CurrentUserProfile> updateProfile(UpdateProfileRequest request);

  Future<void> changePassword(ChangePasswordRequest request);
}
