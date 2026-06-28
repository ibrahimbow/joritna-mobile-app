import 'dart:io';

import 'package:dio/dio.dart';

class ProfileAvatarApiClient {
  const ProfileAvatarApiClient(this._dio);

  final Dio _dio;

  Future<String> uploadAvatar(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'type': 'PROFILE_AVATAR',
    });

    final response = await _dio.post('/files/upload', data: formData);

    return response.data['url'] as String;
  }
}
