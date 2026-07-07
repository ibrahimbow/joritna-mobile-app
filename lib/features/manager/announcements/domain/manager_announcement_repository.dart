import '../data/models/manager_announcement.dart';
import '../data/models/requests/create_manager_announcement_request.dart';
import '../data/models/requests/update_manager_announcement_request.dart';

abstract interface class ManagerAnnouncementRepository {
  Future<List<ManagerAnnouncement>> getAnnouncements();

  Future<ManagerAnnouncement> getAnnouncementById(String id);

  Future<ManagerAnnouncement> createAnnouncement(
    CreateManagerAnnouncementRequest request,
  );

  Future<ManagerAnnouncement> updateAnnouncement(
    String id,
    UpdateManagerAnnouncementRequest request,
  );

  Future<void> deleteAnnouncement(String id);
}
