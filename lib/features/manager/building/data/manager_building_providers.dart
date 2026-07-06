import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../tenant/building/data/models/building.dart';

final managerBuildingApiClientProvider = Provider<ManagerBuildingApiClient>((
  ref,
) {
  return ManagerBuildingApiClient(dio: ref.watch(dioProvider));
});

final myManagedBuildingsProvider = FutureProvider.autoDispose<List<Building>>((
  ref,
) async {
  final apiClient = ref.watch(managerBuildingApiClientProvider);

  return apiClient.getMyManagedBuildings();
});

final myManagedBuildingProvider = FutureProvider.autoDispose<Building?>((
  ref,
) async {
  final buildings = await ref.watch(myManagedBuildingsProvider.future);

  return buildings.isNotEmpty ? buildings.first : null;
});

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

  Future<Building> getMyBuildingById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/manager/buildings/$id',
    );

    return Building.fromJson(response.data!);
  }
}
