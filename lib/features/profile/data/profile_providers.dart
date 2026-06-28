import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/profile_repository.dart';
import 'models/current_user_profile.dart';
import 'profile_api_client.dart';
import 'profile_repository_impl.dart';
import 'profile_avatar_api_client.dart';

final profileApiClientProvider = Provider<ProfileApiClient>((ref) {
  return ProfileApiClient(ref.watch(dioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileApiClientProvider));
});

final profileProvider = FutureProvider<CurrentUserProfile>((ref) async {
  return ref.watch(profileRepositoryProvider).getProfile();
});

final profileAvatarApiClientProvider = Provider<ProfileAvatarApiClient>((ref) {
  return ProfileAvatarApiClient(ref.read(dioProvider));
});
