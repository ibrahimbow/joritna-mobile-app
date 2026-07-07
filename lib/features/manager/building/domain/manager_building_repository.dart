import '../../../tenant/building/data/models/building.dart';
import '../data/models/create_building_request.dart';
import '../data/models/update_building_request.dart';

abstract class ManagerBuildingRepository {
  Future<List<Building>> getMyManagedBuildings();

  Future<Building?> getMyManagedBuilding();

  Future<Building> getMyBuildingById(String id);

  Future<Building> createBuilding(CreateBuildingRequest request);

  Future<Building> updateBuilding({
    required String id,
    required UpdateBuildingRequest request,
  });

  Future<bool> hasMyManagedBuilding();
}
