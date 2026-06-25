class UploadedFile {
  const UploadedFile({
    required this.fileName,
    required this.url,
    required this.contentType,
    required this.size,
  });

  final String fileName;
  final String url;
  final String contentType;
  final int size;

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      fileName: json['fileName'] as String,
      url: json['url'] as String,
      contentType: json['contentType'] as String,
      size: json['size'] as int,
    );
  }
}
