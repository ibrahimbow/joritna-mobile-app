class CurrentUser {
  const CurrentUser({
    required this.userId,
    required this.email,
    required this.role,
    required this.displayName,
    this.avatarUrl,
  });

  final int userId;
  final String email;
  final String role;
  final String displayName;
  final String? avatarUrl;

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      userId: (json['userId'] as num).toInt(),
      email: json['email'] as String,
      role: json['role'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  CurrentUser copyWith({
    int? userId,
    String? email,
    String? role,
    String? displayName,
    String? avatarUrl,
  }) {
    return CurrentUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
