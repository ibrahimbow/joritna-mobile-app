import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import 'models/current_user.dart';
import 'profile_api_client.dart';

final profileApiClientProvider = Provider<ProfileApiClient>((ref) {
  final dio = ref.watch(dioProvider);

  return ProfileApiClient(dio);
});

final currentUserProvider = FutureProvider<CurrentUser>((ref) async {
  final apiClient = ref.watch(profileApiClientProvider);

  return apiClient.getCurrentUser();
});
