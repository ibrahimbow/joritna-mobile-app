import 'package:joritna_mobile/core/user/user_role.dart';

class RegisterRequest {
  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.displayName,
    required this.phoneNumber,
    required this.role,
  });

  final String username;
  final String email;
  final String password;
  final String displayName;
  final String phoneNumber;
  final UserRole role;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'role': role.toBackendValue(),
    };
  }
}

extension UserRoleRegisterMapper on UserRole {
  String toBackendValue() {
    switch (this) {
      case UserRole.manager:
        return 'MANAGER';
      case UserRole.tenant:
        return 'TENANT';
      case UserRole.admin:
        return 'ADMIN';
    }
  }
}
