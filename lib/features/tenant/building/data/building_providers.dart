import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../domain/building_repository.dart';
import 'building_api_client.dart';
import 'building_repository_impl.dart';

final buildingApiClientProvider = Provider<BuildingApiClient>((ref) {
  return BuildingApiClient(
    ref.watch(
      dioProvider,
    ),
  );
});

final buildingRepositoryProvider = Provider<BuildingRepository>((ref) {
  return BuildingRepositoryImpl(
    ref.watch(
      buildingApiClientProvider,
    ),
  );
});

final myBuildingProvider = FutureProvider.autoDispose((ref) async {
  return ref
      .watch(
        buildingRepositoryProvider,
      )
      .getMyBuilding();
});