import '../data/models/announcement.dart';

abstract interface class AnnouncementRepository {
  Future<List<Announcement>> getTenantAnnouncements();
}
