import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../push_device_registration_service.dart';
import 'firebase_messaging_provider.dart';
import 'push_device_repository_provider.dart';

final pushDeviceRegistrationServiceProvider =
    Provider<PushDeviceRegistrationService>((ref) {
      final service = PushDeviceRegistrationService(
        firebaseMessagingService: ref.watch(firebaseMessagingServiceProvider),
        repository: ref.watch(pushDeviceRepositoryProvider),
      );

      ref.onDispose(service.dispose);

      return service;
    });
