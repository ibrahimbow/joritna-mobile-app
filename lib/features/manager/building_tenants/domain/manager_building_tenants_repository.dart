import '../data/models/manager_building_tenant.dart';

abstract interface class ManagerBuildingTenantsRepository {
  Future<List<ManagerBuildingTenant>> getBuildingTenants(String buildingId);

  Future<void> removeTenantFromBuilding({
    required String buildingId,
    required int tenantUserId,
  });
}
