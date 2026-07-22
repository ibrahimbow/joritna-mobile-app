final class RemovePushDeviceRequest {
  const RemovePushDeviceRequest({required this.registrationToken});

  final String registrationToken;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'registrationToken': registrationToken};
  }
}
