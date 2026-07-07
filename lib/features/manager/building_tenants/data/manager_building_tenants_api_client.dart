import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import 'models/manager_building_tenant.dart';

class ManagerBuildingTenantsApiClient {
  final Dio _dio;

  const ManagerBuildingTenantsApiClient(this._dio);

  Future<List<ManagerBuildingTenant>> getBuildingTenants(
    String buildingId,
  ) async {
    final endpoint = '${ApiEndpoints.managerBuildings}/$buildingId/tenants';

    final response = await _dio.get<List<dynamic>>(endpoint);

    final data = response.data ?? [];

    return data
        .map(
          (item) =>
              ManagerBuildingTenant.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> removeTenantFromBuilding({
    required String buildingId,
    required int tenantUserId,
  }) async {
    final endpoint =
        '${ApiEndpoints.managerBuildings}/$buildingId/tenants/$tenantUserId';

    await _dio.delete<void>(endpoint);
  }
}
