import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/push_device_repository.dart';
import 'push_device_api_client_provider.dart';

final pushDeviceRepositoryProvider = Provider<PushDeviceRepository>((ref) {
  return PushDeviceRepository(
    apiClient: ref.watch(pushDeviceApiClientProvider),
  );
});
