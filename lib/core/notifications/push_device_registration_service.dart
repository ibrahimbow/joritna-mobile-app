import 'dart:async';

import 'firebase_messaging_service.dart';
import 'repositories/push_device_repository.dart';

final class PushDeviceRegistrationService {
  PushDeviceRegistrationService({
    required FirebaseMessagingService firebaseMessagingService,
    required PushDeviceRepository repository,
  }) : _firebaseMessagingService = firebaseMessagingService,
       _repository = repository;

  final FirebaseMessagingService _firebaseMessagingService;
  final PushDeviceRepository _repository;

  StreamSubscription<String>? _tokenRefreshSubscription;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    final String? token = await _firebaseMessagingService
        .requestPermissionAndGetToken();

    if (token == null) {
      return;
    }

    await _registerToken(token);

    _tokenRefreshSubscription = _firebaseMessagingService.onTokenRefresh.listen(
      _registerToken,
    );
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();

    _tokenRefreshSubscription = null;
    _initialized = false;
  }

  Future<void> _registerToken(final String token) {
    return _repository.registerPushDevice(
      registrationToken: token,
      platform: 'ANDROID',
      deviceName: null,
      appVersion: null,
    );
  }
}
