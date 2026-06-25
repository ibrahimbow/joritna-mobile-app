import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_provider.dart';
import 'file_api_client.dart';
import 'file_repository.dart';

final fileApiClientProvider = Provider<FileApiClient>((ref) {
  final dio = ref.watch(dioProvider);

  return FileApiClient(dio);
});

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  final fileApiClient = ref.watch(fileApiClientProvider);

  return FileRepository(fileApiClient);
});
