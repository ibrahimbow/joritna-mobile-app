import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../domain/share_and_help_repository.dart';
import 'share_and_help_api_client.dart';
import 'share_and_help_repository_impl.dart';

final shareAndHelpApiClientProvider = Provider<ShareAndHelpApiClient>((ref) {
  final dio = ref.watch(dioProvider);

  return ShareAndHelpApiClient(dio);
});

final shareAndHelpRepositoryProvider = Provider<ShareAndHelpRepository>((ref) {
  return ShareAndHelpRepositoryImpl(ref.watch(shareAndHelpApiClientProvider));
});

final shareAndHelpPostsProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.watch(shareAndHelpRepositoryProvider);

  return repository.getPosts();
});
