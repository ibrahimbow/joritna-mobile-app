class Announcement {
  const Announcement({
    required this.id,
    required this.buildingId,
    required this.title,
    required this.message,
    required this.category,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.icon,
    this.imageUrl,
  });

  final String id;
  final String buildingId;
  final String title;
  final String message;
  final String category;
  final String? icon;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      buildingId: json['buildingId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      category: json['category'] as String,
      icon: json['icon'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }
}
