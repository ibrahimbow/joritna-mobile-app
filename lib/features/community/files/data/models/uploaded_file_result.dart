class UploadedFileResult {
  final String fileName;
  final String url;
  final String contentType;
  final int size;

  const UploadedFileResult({
    required this.fileName,
    required this.url,
    required this.contentType,
    required this.size,
  });

  factory UploadedFileResult.fromJson(Map<String, dynamic> json) {
    return UploadedFileResult(
      fileName: json['fileName'] as String,
      url: json['url'] as String,
      contentType: json['contentType'] as String,
      size: json['size'] as int,
    );
  }
}