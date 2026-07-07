import '../manager_announcement.dart';

class UpdateManagerAnnouncementRequest {
  final String title;
  final String message;
  final AnnouncementCategory category;
  final String? imageUrl;

  const UpdateManagerAnnouncementRequest({
    required this.title,
    required this.message,
    required this.category,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'category': category.apiValue,
      'imageUrl': imageUrl,
    };
  }
}
