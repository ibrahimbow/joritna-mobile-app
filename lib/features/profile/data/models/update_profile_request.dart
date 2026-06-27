class UpdateProfileRequest {
  const UpdateProfileRequest({
    required this.displayName,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.preferredLanguage,
    required this.notificationsEnabled,
  });

  final String displayName;
  final String phoneNumber;
  final String? avatarUrl;
  final String preferredLanguage;
  final bool notificationsEnabled;

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'preferredLanguage': preferredLanguage,
      'notificationsEnabled': notificationsEnabled,
    };
  }
}
