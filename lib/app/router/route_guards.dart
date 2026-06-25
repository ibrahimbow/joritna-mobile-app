import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/token_storage_provider.dart';

class RouteGuards {
  const RouteGuards._();

  static Future<bool> isAuthenticated(Ref ref) async {
    final tokenStorage = ref.read(tokenStorageProvider);

    final accessToken = await tokenStorage.getAccessToken();

    return accessToken != null && accessToken.trim().isNotEmpty;
  }
}
