import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'secure_storage_provider.dart';
import 'token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);

  return TokenStorage(secureStorage);
});
