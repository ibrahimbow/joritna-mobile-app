import 'file_api_client.dart';
import 'file_type.dart';
import 'uploaded_file.dart';

class FileRepository {
  const FileRepository(this._fileApiClient);

  final FileApiClient _fileApiClient;

  Future<UploadedFile> upload({
    required String filePath,
    required FileType type,
  }) async {
    return _fileApiClient.upload(filePath: filePath, type: type);
  }
}
