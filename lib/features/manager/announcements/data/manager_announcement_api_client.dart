import 'package:dio/dio.dart';

import 'models/manager_announcement.dart';
import 'models/requests/create_manager_announcement_request.dart';
import 'models/requests/update_manager_announcement_request.dart';

class ManagerAnnouncementApiClient {
  final Dio _dio;

  const ManagerAnnouncementApiClient(this._dio);

  static const String _basePath = '/manager/announcements';

  Future<List<ManagerAnnouncement>> getAnnouncements() async {
    final response = await _dio.get<List<dynamic>>(_basePath);

    return response.data!
        .map(
          (json) => ManagerAnnouncement.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<ManagerAnnouncement> getAnnouncementById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('$_basePath/$id');

    return ManagerAnnouncement.fromJson(response.data!);
  }

  Future<ManagerAnnouncement> createAnnouncement(
    CreateManagerAnnouncementRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _basePath,
      data: request.toJson(),
    );

    return ManagerAnnouncement.fromJson(response.data!);
  }

  Future<ManagerAnnouncement> updateAnnouncement(
    String id,
    UpdateManagerAnnouncementRequest request,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '$_basePath/$id',
      data: request.toJson(),
    );

    return ManagerAnnouncement.fromJson(response.data!);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _dio.delete<void>('$_basePath/$id');
  }
}
