import '../../../tenant/building/data/models/building.dart';
import '../domain/manager_building_repository.dart';
import 'manager_building_api_client.dart';
import 'models/create_building_request.dart';
import 'models/update_building_request.dart';

class ManagerBuildingRepositoryImpl implements ManagerBuildingRepository {
  final ManagerBuildingApiClient _apiClient;

  const ManagerBuildingRepositoryImpl(this._apiClient);

  @override
  Future<List<Building>> getMyManagedBuildings() {
    return _apiClient.getMyManagedBuildings();
  }

  @override
  Future<Building?> getMyManagedBuilding() {
    return _apiClient.getMyManagedBuilding();
  }

  @override
  Future<Building> getMyBuildingById(String id) {
    return _apiClient.getMyBuildingById(id);
  }

  @override
  Future<Building> createBuilding(CreateBuildingRequest request) {
    return _apiClient.createBuilding(request);
  }

  @override
  Future<Building> updateBuilding({
    required String id,
    required UpdateBuildingRequest request,
  }) {
    return _apiClient.updateBuilding(id: id, request: request);
  }

  @override
  Future<bool> hasMyManagedBuilding() async {
    final building = await getMyManagedBuilding();

    return building != null;
  }
}
