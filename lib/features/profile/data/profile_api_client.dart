import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import 'models/change_password_request.dart';
import 'models/current_user_profile.dart';
import 'models/update_profile_request.dart';

class ProfileApiClient {
  const ProfileApiClient(this._dio);

  final Dio _dio;

  Future<CurrentUserProfile> getProfile() async {
    final response = await _dio.get(ApiEndpoints.authProfile);

    return CurrentUserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CurrentUserProfile> updateProfile(UpdateProfileRequest request) async {
    final response = await _dio.put(
      ApiEndpoints.authProfile,
      data: request.toJson(),
    );

    return CurrentUserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    await _dio.patch(ApiEndpoints.authChangePassword, data: request.toJson());
  }
}
