import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/storage/token_storage_provider.dart';
import '../domain/auth_repository.dart';
import 'auth_api_client.dart';
import 'auth_repository_impl.dart';

final authApiClientProvider = Provider<AuthApiClient>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthApiClient(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authApiClient = ref.watch(authApiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  return AuthRepositoryImpl(authApiClient, tokenStorage);
});
