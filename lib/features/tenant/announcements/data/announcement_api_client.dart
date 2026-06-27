import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import 'models/announcement.dart';

class AnnouncementApiClient {
  const AnnouncementApiClient(this._dio);

  final Dio _dio;

  Future<List<Announcement>> getTenantAnnouncements() async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.tenantAnnouncements,
    );

    final data = response.data ?? [];

    return data
        .map((item) => Announcement.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
