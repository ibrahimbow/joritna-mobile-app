import 'package:dio/dio.dart';

import 'models/building.dart';
import 'models/requests/join_building_request.dart';

class BuildingApiClient {
  final Dio _dio;

  const BuildingApiClient(this._dio);

  static const String _basePath = '/tenant/buildings';

  Future<Building> getMyBuilding() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_basePath/my-building',
    );

    return Building.fromJson(response.data!);
  }

  Future<Building> joinBuilding(JoinBuildingRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_basePath/join',
      data: request.toJson(),
    );

    return Building.fromJson(response.data!);
  }

  Future<void> leaveBuilding() async {
    await _dio.post<void>('$_basePath/my-building/leave');
  }

  Future<Building> getBuildingByCode(String code) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_basePath/code/$code',
    );

    return Building.fromJson(response.data!);
  }
}
