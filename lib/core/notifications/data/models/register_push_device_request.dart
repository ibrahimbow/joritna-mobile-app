final class RegisterPushDeviceRequest {
  const RegisterPushDeviceRequest({
    required this.platform,
    required this.registrationToken,
    this.deviceName,
    this.appVersion,
  });

  final String platform;
  final String registrationToken;
  final String? deviceName;
  final String? appVersion;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'platform': platform,
      'registrationToken': registrationToken,
      'deviceName': deviceName,
      'appVersion': appVersion,
    };
  }
}
