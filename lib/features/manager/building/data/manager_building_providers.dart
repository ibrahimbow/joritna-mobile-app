import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../tenant/building/data/models/building.dart';
import '../domain/manager_building_repository.dart';
import 'manager_building_api_client.dart';
import 'manager_building_repository_impl.dart';

final managerBuildingApiClientProvider = Provider<ManagerBuildingApiClient>((
  ref,
) {
  final dio = ref.watch(dioProvider);

  return ManagerBuildingApiClient(dio: dio);
});

final managerBuildingRepositoryProvider = Provider<ManagerBuildingRepository>((
  ref,
) {
  final apiClient = ref.watch(managerBuildingApiClientProvider);

  return ManagerBuildingRepositoryImpl(apiClient);
});

final myManagedBuildingsProvider = FutureProvider.autoDispose<List<Building>>((
  ref,
) async {
  final repository = ref.watch(managerBuildingRepositoryProvider);

  return repository.getMyManagedBuildings();
});

final myManagedBuildingProvider = FutureProvider.autoDispose<Building?>((
  ref,
) async {
  final repository = ref.watch(managerBuildingRepositoryProvider);

  return repository.getMyManagedBuilding();
});
