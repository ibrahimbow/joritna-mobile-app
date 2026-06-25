class JoinBuildingRequest {
  final String code;

  const JoinBuildingRequest({
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
    };
  }
}