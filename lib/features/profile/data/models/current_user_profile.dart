import 'package:joritna_mobile/core/user/user_role.dart';

class CurrentUserProfile {
  const CurrentUserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.preferredLanguage,
    required this.notificationsEnabled,
    required this.role,
  });

  final int id;
  final String username;
  final String email;
  final String displayName;
  final String phoneNumber;
  final String? avatarUrl;
  final String preferredLanguage;
  final bool notificationsEnabled;
  final UserRole role;

  factory CurrentUserProfile.fromJson(Map<String, dynamic> json) {
    return CurrentUserProfile(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'EN',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      role: UserRole.from(json['role'] as String),
    );
  }
}
