import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../push_device_removal_service.dart';
import 'firebase_messaging_provider.dart';
import 'push_device_repository_provider.dart';

final pushDeviceRemovalServiceProvider = Provider<PushDeviceRemovalService>((
  ref,
) {
  return PushDeviceRemovalService(
    firebaseMessagingService: ref.watch(firebaseMessagingServiceProvider),
    repository: ref.watch(pushDeviceRepositoryProvider),
  );
});
