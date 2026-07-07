class ManagerBuildingTenant {
  final int tenantUserId;
  final String username;
  final String email;
  final String? phoneNumber;

  const ManagerBuildingTenant({
    required this.tenantUserId,
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  factory ManagerBuildingTenant.fromJson(Map<String, dynamic> json) {
    return ManagerBuildingTenant(
      tenantUserId: json['tenantUserId'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }
}
