import '../data/models/current_user_profile.dart';
import '../data/models/update_profile_request.dart';

abstract interface class ProfileRepository {
  Future<CurrentUserProfile> getProfile();

  Future<CurrentUserProfile> updateProfile(UpdateProfileRequest request);
}
