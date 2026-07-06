import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/security/jwt_claims_reader.dart';
import '../../core/storage/token_storage_provider.dart';

class RouteGuards {
  const RouteGuards._();

  static Future<bool> isAuthenticated(Ref ref) async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final accessToken = await tokenStorage.getAccessToken();

    return accessToken != null && accessToken.trim().isNotEmpty;
  }

  static Future<String?> currentUserRole(Ref ref) async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null || accessToken.trim().isEmpty) {
      return null;
    }

    return const JwtClaimsReader().readRole(accessToken);
  }

  static Future<bool> hasRole(Ref ref, {required String role}) async {
    final currentRole = await currentUserRole(ref);

    return currentRole == role.toUpperCase();
  }
}
