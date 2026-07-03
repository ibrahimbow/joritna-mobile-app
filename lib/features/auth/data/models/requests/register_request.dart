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
  final String role;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }
}
