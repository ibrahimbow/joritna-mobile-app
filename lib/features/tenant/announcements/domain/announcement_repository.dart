import '../data/models/announcement.dart';

abstract class AnnouncementRepository {
  Future<List<Announcement>> getTenantAnnouncements();
}
