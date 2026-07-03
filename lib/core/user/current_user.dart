class CurrentUser {
  const CurrentUser({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.role,
    required this.preferredLanguage,
    required this.notificationsEnabled,
    this.avatarUrl,
  });

  final int id;
  final String username;
  final String email;
  final String displayName;
  final String phoneNumber;
  final String role;
  final String preferredLanguage;
  final bool notificationsEnabled;
  final String? avatarUrl;

  int get userId => id;

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      id: (json['id'] ?? json['userId'] as num).toInt(),
      username: json['username'] as String? ?? '',
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      role: json['role'] as String,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'EN',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  CurrentUser copyWith({
    int? id,
    String? username,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? role,
    String? preferredLanguage,
    bool? notificationsEnabled,
    String? avatarUrl,
  }) {
    return CurrentUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
