import 'package:dio/dio.dart';

import 'models/current_user.dart';

class ProfileApiClient {

  final Dio _dio;

  ProfileApiClient(this._dio);

  Future<CurrentUser> getCurrentUser() async {
    final response = await _dio.get('/auth/profile');

    return CurrentUser.fromJson(response.data);
  }
}