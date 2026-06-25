import 'package:dio/dio.dart';

import '../network/api_endpoints.dart';
import 'file_type.dart';
import 'uploaded_file.dart';

class FileApiClient {
  const FileApiClient(this._dio);

  final Dio _dio;

  Future<UploadedFile> upload({
    required String filePath,
    required FileType type,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'type': type.apiValue,
    });

    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.fileUpload,
      data: formData,
    );

    final data = response.data;

    if (data == null) {
      throw StateError('File upload failed. Empty response body.');
    }

    return UploadedFile.fromJson(data);
  }
}
