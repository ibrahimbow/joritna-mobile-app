import '../domain/announcement_repository.dart';
import 'announcement_api_client.dart';
import 'models/announcement.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  const AnnouncementRepositoryImpl(this._apiClient);

  final AnnouncementApiClient _apiClient;

  @override
  Future<List<Announcement>> getTenantAnnouncements() {
    return _apiClient.getTenantAnnouncements();
  }
}
