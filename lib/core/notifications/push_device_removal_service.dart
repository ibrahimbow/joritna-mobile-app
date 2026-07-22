import 'dart:developer' as developer;

import 'firebase_messaging_service.dart';
import 'repositories/push_device_repository.dart';

final class PushDeviceRemovalService {
  PushDeviceRemovalService({
    required FirebaseMessagingService firebaseMessagingService,
    required PushDeviceRepository repository,
  }) : _firebaseMessagingService = firebaseMessagingService,
       _repository = repository;

  final FirebaseMessagingService _firebaseMessagingService;
  final PushDeviceRepository _repository;

  Future<void> removeCurrentDevice() async {
    try {
      final String? registrationToken = await _firebaseMessagingService
          .getRegistrationToken();

      if (registrationToken == null) {
        return;
      }

      await _repository.removePushDevice(registrationToken: registrationToken);

      await _firebaseMessagingService.deleteRegistrationToken();
    } on Object catch (exception, stackTrace) {
      developer.log(
        'Failed to remove push device.',
        name: 'PushDeviceRemovalService',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }
}
