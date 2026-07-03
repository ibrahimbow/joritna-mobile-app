import 'dart:io';

import 'package:dio/dio.dart';

class ChatFileApiClient {
  const ChatFileApiClient(this._dio);

  final Dio _dio;

  Future<String> uploadChatImage(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'type': 'CHAT_MESSAGE_IMAGE',
    });

    final response = await _dio.post('/files/upload', data: formData);

    return response.data['url'] as String;
  }
}
