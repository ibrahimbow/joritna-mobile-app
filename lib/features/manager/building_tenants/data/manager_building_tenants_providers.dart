import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../domain/manager_building_tenants_repository.dart';
import 'manager_building_tenants_api_client.dart';
import 'manager_building_tenants_repository_impl.dart';
import 'models/manager_building_tenant.dart';

final managerBuildingTenantsApiClientProvider =
    Provider<ManagerBuildingTenantsApiClient>((ref) {
      final dio = ref.watch(dioProvider);

      return ManagerBuildingTenantsApiClient(dio);
    });

final managerBuildingTenantsRepositoryProvider =
    Provider<ManagerBuildingTenantsRepository>((ref) {
      final apiClient = ref.watch(managerBuildingTenantsApiClientProvider);

      return ManagerBuildingTenantsRepositoryImpl(apiClient);
    });

final managerBuildingTenantsProvider =
    FutureProvider.family<List<ManagerBuildingTenant>, String>((
      ref,
      buildingId,
    ) async {
      final repository = ref.watch(managerBuildingTenantsRepositoryProvider);

      return repository.getBuildingTenants(buildingId);
    });
