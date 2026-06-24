import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'models/login_request.dart';
import 'models/login_response.dart';

class AuthApiClient {
  const AuthApiClient(this._dio);

  final Dio _dio;

  Future<LoginResponse> login(LoginRequest request) async {
    final body = request.toJson();

    debugPrint('LOGIN URL: ${_dio.options.baseUrl}/auth/login');
    debugPrint('LOGIN BODY usernameOrEmail=[${body['usernameOrEmail']}]');
    debugPrint('LOGIN BODY passwordLength=[${body['password'].toString().length}]');

    final response = await _dio.post(
      '/auth/login',
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    debugPrint('LOGIN STATUS: ${response.statusCode}');
    debugPrint('LOGIN RESPONSE: ${response.data}');

    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }
}