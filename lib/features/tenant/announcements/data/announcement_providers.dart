import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../domain/announcement_repository.dart';
import 'announcement_api_client.dart';
import 'announcement_repository_impl.dart';
import 'models/announcement.dart';

final announcementApiClientProvider = Provider<AnnouncementApiClient>((ref) {
  final dio = ref.watch(dioProvider);

  return AnnouncementApiClient(dio);
});

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  final apiClient = ref.watch(announcementApiClientProvider);

  return AnnouncementRepositoryImpl(apiClient);
});

final tenantAnnouncementsProvider = FutureProvider<List<Announcement>>((
  ref,
) async {
  final repository = ref.watch(announcementRepositoryProvider);

  return repository.getTenantAnnouncements();
});
