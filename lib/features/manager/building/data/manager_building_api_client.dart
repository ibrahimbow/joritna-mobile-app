import 'package:dio/dio.dart';

import '../../../tenant/building/data/models/building.dart';
import 'models/create_building_request.dart';
import 'models/update_building_request.dart';

class ManagerBuildingApiClient {
  const ManagerBuildingApiClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<Building>> getMyManagedBuildings() async {
    final response = await _dio.get<List<dynamic>>('/manager/buildings');

    final data = response.data ?? <dynamic>[];

    return data
        .map((json) => Building.fromJson(json as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Building?> getMyManagedBuilding() async {
    final buildings = await getMyManagedBuildings();

    return buildings.isNotEmpty ? buildings.first : null;
  }

  Future<Building> getMyBuildingById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/manager/buildings/$id',
    );

    return Building.fromJson(response.data!);
  }

  Future<Building> createBuilding(CreateBuildingRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/manager/buildings',
      data: request.toJson(),
    );

    return Building.fromJson(response.data!);
  }

  Future<Building> updateBuilding({
    required String id,
    required UpdateBuildingRequest request,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/manager/buildings/$id',
      data: request.toJson(),
    );

    return Building.fromJson(response.data!);
  }
}
