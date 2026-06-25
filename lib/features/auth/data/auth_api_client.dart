import 'package:dio/dio.dart';

import 'models/login_request.dart';
import 'models/login_response.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/user/current_user.dart';

class AuthApiClient {
  const AuthApiClient(this._dio);

  final Dio _dio;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.authLogin,
      data: request.toJson(),
    );

    final data = response.data;

    if (data == null) {
      throw StateError('Login failed. Empty response body.');
    }

    return LoginResponse.fromJson(data);
  }

  Future<CurrentUser> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.authProfile,
    );

    final data = response.data;

    if (data == null) {
      throw StateError(
        'Could not load current user profile. Empty response body.',
      );
    }

    return CurrentUser.fromJson(data);
  }
}
