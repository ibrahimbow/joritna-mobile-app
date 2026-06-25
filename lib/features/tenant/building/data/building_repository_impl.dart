import '../domain/building_repository.dart';
import 'building_api_client.dart';
import 'models/building.dart';
import 'models/requests/join_building_request.dart';

class BuildingRepositoryImpl implements BuildingRepository {
  final BuildingApiClient _apiClient;

  const BuildingRepositoryImpl(
    this._apiClient,
  );

  @override
  Future<Building> getMyBuilding() {
    return _apiClient.getMyBuilding();
  }

  @override
  Future<Building> joinBuilding(
    JoinBuildingRequest request,
  ) {
    return _apiClient.joinBuilding(
      request,
    );
  }

  @override
  Future<void> leaveBuilding() {
    return _apiClient.leaveBuilding();
  }

  @override
  Future<Building> getBuildingByCode(
    String code,
  ) {
    return _apiClient.getBuildingByCode(
      code,
    );
  }

  @override
Future<bool> hasMyBuilding() async {
  try {
    await _apiClient.getMyBuilding();
    return true;
  } catch (_) {
    return false;
  }
}
}