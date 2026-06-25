import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/token_storage_provider.dart';

final authStateProvider = FutureProvider<bool>((ref) async {
  final tokenStorage = ref.watch(tokenStorageProvider);

  final token = await tokenStorage.getAccessToken();

  return token != null && token.isNotEmpty;
});
