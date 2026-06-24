class CurrentUser {
  final int id;
  final String username;
  final String email;
  final String displayName;
  final String phoneNumber;
  final String? avatarUrl;
  final String preferredLanguage;
  final bool notificationsEnabled;
  final String role;

  const CurrentUser({
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

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
      preferredLanguage: json['preferredLanguage'] ?? 'EN',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      role: json['role'],
    );
  }
}