import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../domain/manager_announcement_repository.dart';
import 'manager_announcement_api_client.dart';
import 'manager_announcement_repository_impl.dart';
import 'models/manager_announcement.dart';

final managerAnnouncementApiClientProvider =
    Provider<ManagerAnnouncementApiClient>((ref) {
      final dio = ref.watch(dioProvider);
      return ManagerAnnouncementApiClient(dio);
    });

final managerAnnouncementRepositoryProvider =
    Provider<ManagerAnnouncementRepository>((ref) {
      final apiClient = ref.watch(managerAnnouncementApiClientProvider);
      return ManagerAnnouncementRepositoryImpl(apiClient);
    });

final managerAnnouncementsProvider =
    FutureProvider.autoDispose<List<ManagerAnnouncement>>((ref) {
      return ref
          .watch(managerAnnouncementRepositoryProvider)
          .getAnnouncements();
    });
