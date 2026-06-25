import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_providers.dart';
import 'current_user.dart';

final currentUserProvider = FutureProvider<CurrentUser>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final profile = await authRepository.getProfile();

  return CurrentUser(
    userId: profile.userId,
    email: profile.email,
    displayName: profile.displayName,
    role: profile.role,
    avatarUrl: profile.avatarUrl,
  );
});
