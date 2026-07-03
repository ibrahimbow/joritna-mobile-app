class RegisterResponse {
  const RegisterResponse({required this.id});

  final int id;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(id: (json['id'] as num).toInt());
  }
}
