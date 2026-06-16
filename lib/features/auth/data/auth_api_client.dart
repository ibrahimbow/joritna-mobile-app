import 'package:dio/dio.dart';

import 'models/login_request.dart';
import 'models/login_response.dart';

class AuthApiClient {
  const AuthApiClient(this._dio);

  final Dio _dio;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '/auth/login',
      data: request.toJson(),
    );

    return LoginResponse.fromJson(response.data);
  }
}