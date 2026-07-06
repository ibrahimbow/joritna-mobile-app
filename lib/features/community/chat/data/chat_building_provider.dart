import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/user/current_user_provider.dart';
import '../../../../core/user/user_role.dart';
import '../../../manager/building/data/manager_building_providers.dart';
import '../../../tenant/building/data/building_providers.dart';
import '../../../tenant/building/data/models/building.dart';

final chatBuildingProvider = FutureProvider.autoDispose<Building>((ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);

  final Building? building = switch (currentUser.role) {
    UserRole.tenant => await ref.watch(myBuildingProvider.future),
    UserRole.manager => await ref.watch(myManagedBuildingProvider.future),
    UserRole.admin => await ref.watch(myManagedBuildingProvider.future),
  };

  if (building == null) {
    throw StateError('No building available for chat.');
  }

  return building;
});
