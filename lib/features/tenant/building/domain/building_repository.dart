import '../data/models/building.dart';
import '../data/models/requests/join_building_request.dart';

abstract class BuildingRepository {
  Future<Building> getMyBuilding();

  Future<Building> joinBuilding(
    JoinBuildingRequest request,
  );

  Future<bool> hasMyBuilding();

  Future<void> leaveBuilding();

  Future<Building> getBuildingByCode(
    String code,
  );
}