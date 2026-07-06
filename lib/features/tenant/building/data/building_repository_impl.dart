import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/errors/api_failure.dart';
import '../domain/building_repository.dart';
import 'building_api_client.dart';
import 'models/building.dart';
import 'models/requests/join_building_request.dart';

class BuildingRepositoryImpl implements BuildingRepository {
  const BuildingRepositoryImpl(this._apiClient);

  final BuildingApiClient _apiClient;

  @override
  Future<Building> getMyBuilding() async {
    try {
      return await _apiClient.getMyBuilding();
    } catch (error) {
      throw _mapFailure(
        error,
        fallbackMessage: 'Unable to load your building.',
      );
    }
  }

  @override
  Future<Building> joinBuilding(JoinBuildingRequest request) async {
    try {
      return await _apiClient.joinBuilding(request);
    } catch (error) {
      throw _mapFailure(error, fallbackMessage: 'Unable to join the building.');
    }
  }

  @override
  Future<void> leaveBuilding() async {
    try {
      await _apiClient.leaveBuilding();
    } catch (error) {
      throw _mapFailure(
        error,
        fallbackMessage: 'Unable to leave the building.',
      );
    }
  }

  @override
  Future<Building> getBuildingByCode(String code) async {
    try {
      return await _apiClient.getBuildingByCode(code);
    } catch (error) {
      throw _mapFailure(error, fallbackMessage: 'Unable to load the building.');
    }
  }

  @override
  Future<bool> hasMyBuilding() async {
    try {
      await _apiClient.getMyBuilding();
      return true;
    } catch (error) {
      final failure = _mapFailure(
        error,
        fallbackMessage: 'Unable to load your building.',
      );

      if (failure.isNotFound) {
        return false;
      }

      throw failure;
    }
  }

  static ApiFailure _mapFailure(
    Object error, {
    required String fallbackMessage,
  }) {
    return FailureMapper.map(error, fallbackMessage: fallbackMessage);
  }
}
