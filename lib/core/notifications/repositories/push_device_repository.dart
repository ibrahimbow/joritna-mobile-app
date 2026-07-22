import '../data/models/register_push_device_request.dart';
import '../data/models/remove_push_device_request.dart';
import '../data/remote/push_device_api_client.dart';

final class PushDeviceRepository {
  PushDeviceRepository({required PushDeviceApiClient apiClient})
    : _apiClient = apiClient;

  final PushDeviceApiClient _apiClient;

  Future<void> registerPushDevice({
    required final String registrationToken,
    required final String platform,
    final String? deviceName,
    final String? appVersion,
  }) {
    return _apiClient.registerPushDevice(
      RegisterPushDeviceRequest(
        platform: platform,
        registrationToken: registrationToken,
        deviceName: deviceName,
        appVersion: appVersion,
      ),
    );
  }

  Future<void> removePushDevice({required final String registrationToken}) {
    return _apiClient.removePushDevice(
      RemovePushDeviceRequest(registrationToken: registrationToken),
    );
  }
}
