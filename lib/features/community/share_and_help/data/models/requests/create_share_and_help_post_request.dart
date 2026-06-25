class CreateShareAndHelpPostRequest {
  final String title;
  final String description;
  final String? imageUrl;

  const CreateShareAndHelpPostRequest({
    required this.title,
    required this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}