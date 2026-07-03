import 'package:dio/dio.dart';
import '../../../core/user/current_user.dart';

class ProfileApiClient {
  final Dio _dio;

  ProfileApiClient(this._dio);

  Future<CurrentUser> getCurrentUser() async {
    final response = await _dio.get('/auth/profile');

    return CurrentUser.fromJson(response.data);
  }
}
