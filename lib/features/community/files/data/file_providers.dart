import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import 'file_api_client.dart';

final fileApiClientProvider = Provider<FileApiClient>((ref) {
  final dio = ref.watch(dioProvider);

  return FileApiClient(
    dio,
  );
});