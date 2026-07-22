import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/dio_provider.dart';
import '../data/remote/push_device_api_client.dart';

final pushDeviceApiClientProvider = Provider<PushDeviceApiClient>((ref) {
  return PushDeviceApiClient(dio: ref.watch(dioProvider));
});
