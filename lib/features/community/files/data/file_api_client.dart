import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/file/file_type.dart';
import '../../../../../core/file/uploaded_file.dart';

class FileApiClient {
  const FileApiClient(this._dio);

  final Dio _dio;

  Future<UploadedFile> uploadImage({
    required XFile image,
    required FileType type,
  }) async {
    final formData = FormData.fromMap({
      'type': type.apiValue,
      'file': await MultipartFile.fromFile(image.path, filename: image.name),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/files/upload',
      data: formData,
    );

    return UploadedFile.fromJson(response.data!);
  }
}
