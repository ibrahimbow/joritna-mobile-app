enum UserRole {
  admin,
  manager,
  tenant;

  static UserRole from(String role) {
    switch (role.trim().toUpperCase()) {
      case 'ADMIN':
        return UserRole.admin;
      case 'MANAGER':
        return UserRole.manager;
      case 'TENANT':
        return UserRole.tenant;
      default:
        throw ArgumentError('Unknown role: $role');
    }
  }

  String get displayName {
    return switch (this) {
      UserRole.admin => 'ADMIN',
      UserRole.manager => 'MANAGER',
      UserRole.tenant => 'TENANT',
    };
  }

  bool get isAdmin => this == UserRole.admin;

  bool get isManager => this == UserRole.manager;

  bool get isTenant => this == UserRole.tenant;
}
