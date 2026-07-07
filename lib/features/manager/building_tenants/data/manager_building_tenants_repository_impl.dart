import '../../../../core/errors/failure_mapper.dart';
import '../domain/manager_building_tenants_repository.dart';
import 'manager_building_tenants_api_client.dart';
import 'models/manager_building_tenant.dart';

class ManagerBuildingTenantsRepositoryImpl
    implements ManagerBuildingTenantsRepository {
  final ManagerBuildingTenantsApiClient _apiClient;

  const ManagerBuildingTenantsRepositoryImpl(this._apiClient);

  @override
  Future<List<ManagerBuildingTenant>> getBuildingTenants(
    String buildingId,
  ) async {
    try {
      return await _apiClient.getBuildingTenants(buildingId);
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to load building tenants.',
      );
    }
  }

  @override
  Future<void> removeTenantFromBuilding({
    required String buildingId,
    required int tenantUserId,
  }) async {
    try {
      await _apiClient.removeTenantFromBuilding(
        buildingId: buildingId,
        tenantUserId: tenantUserId,
      );
    } catch (error) {
      throw FailureMapper.map(
        error,
        fallbackMessage: 'Unable to remove tenant from building.',
      );
    }
  }
}
