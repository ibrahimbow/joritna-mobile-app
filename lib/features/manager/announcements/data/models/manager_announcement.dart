class ManagerAnnouncement {
  final String id;
  final String buildingId;
  final String title;
  final String message;
  final AnnouncementCategory category;
  final String? icon;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ManagerAnnouncement({
    required this.id,
    required this.buildingId,
    required this.title,
    required this.message,
    required this.category,
    required this.icon,
    required this.imageUrl,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ManagerAnnouncement.fromJson(Map<String, dynamic> json) {
    return ManagerAnnouncement(
      id: json['id'] as String,
      buildingId: json['buildingId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      category: AnnouncementCategory.fromJson(json['category'] as String),
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

enum AnnouncementCategory {
  general,
  maintenance,
  emergency,
  event,
  reminder,
  safety;

  String get apiValue => name.toUpperCase();

  String get label {
    switch (this) {
      case AnnouncementCategory.general:
        return 'General';
      case AnnouncementCategory.maintenance:
        return 'Maintenance';
      case AnnouncementCategory.emergency:
        return 'Emergency';
      case AnnouncementCategory.event:
        return 'Event';
      case AnnouncementCategory.reminder:
        return 'Reminder';
      case AnnouncementCategory.safety:
        return 'Safety';
    }
  }

  static AnnouncementCategory fromJson(String value) {
    return AnnouncementCategory.values.firstWhere(
      (category) => category.apiValue == value.toUpperCase(),
      orElse: () => AnnouncementCategory.general,
    );
  }
}
