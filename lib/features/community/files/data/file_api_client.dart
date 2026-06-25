import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'models/uploaded_file_result.dart';

class FileApiClient {
  final Dio _dio;

  const FileApiClient(
    this._dio,
  );

  Future<UploadedFileResult> uploadShareAndHelpImage(
    XFile image,
  ) async {
    final formData = FormData.fromMap({
      'type': 'SHARE_AND_HELP_IMAGE',
      'file': await MultipartFile.fromFile(
        image.path,
        filename: image.name,
      ),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/files/upload',
      data: formData,
    );

    return UploadedFileResult.fromJson(
      response.data!,
    );
  }
}