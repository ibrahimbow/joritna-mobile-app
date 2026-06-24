class LoginRequest {
  final String usernameOrEmail;
  final String password;

  const LoginRequest({
    required this.usernameOrEmail,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'usernameOrEmail': usernameOrEmail.trim(),
      'password': password,
    };
  }
}