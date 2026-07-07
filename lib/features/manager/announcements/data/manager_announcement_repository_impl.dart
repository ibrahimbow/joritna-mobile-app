import '../../../../core/errors/failure_mapper.dart';
import '../domain/manager_announcement_repository.dart';
import 'manager_announcement_api_client.dart';
import 'models/manager_announcement.dart';
import 'models/requests/create_manager_announcement_request.dart';
import 'models/requests/update_manager_announcement_request.dart';

class ManagerAnnouncementRepositoryImpl
    implements ManagerAnnouncementRepository {
  final ManagerAnnouncementApiClient _apiClient;

  const ManagerAnnouncementRepositoryImpl(this._apiClient);

  @override
  Future<List<ManagerAnnouncement>> getAnnouncements() async {
    try {
      return await _apiClient.getAnnouncements();
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to load announcements.',
      );
    }
  }

  @override
  Future<ManagerAnnouncement> getAnnouncementById(String id) async {
    try {
      return await _apiClient.getAnnouncementById(id);
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to load announcement details.',
      );
    }
  }

  @override
  Future<ManagerAnnouncement> createAnnouncement(
    CreateManagerAnnouncementRequest request,
  ) async {
    try {
      return await _apiClient.createAnnouncement(request);
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to create announcement.',
      );
    }
  }

  @override
  Future<ManagerAnnouncement> updateAnnouncement(
    String id,
    UpdateManagerAnnouncementRequest request,
  ) async {
    try {
      return await _apiClient.updateAnnouncement(id, request);
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to update announcement.',
      );
    }
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    try {
      await _apiClient.deleteAnnouncement(id);
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to delete announcement.',
      );
    }
  }
}
