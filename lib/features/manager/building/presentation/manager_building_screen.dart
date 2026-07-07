import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/layout/app_shell.dart';
import '../data/manager_building_providers.dart';
import 'widgets/manager_building_details.dart';
import 'widgets/manager_building_form.dart';

class ManagerBuildingScreen extends ConsumerStatefulWidget {
  const ManagerBuildingScreen({super.key});

  @override
  ConsumerState<ManagerBuildingScreen> createState() =>
      _ManagerBuildingScreenState();
}

class _ManagerBuildingScreenState extends ConsumerState<ManagerBuildingScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final buildingState = ref.watch(myManagedBuildingProvider);

    return AppShell(
      selectedIndex: 1,
      child: buildingState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const ManagerBuildingForm(),
        data: (building) {
          if (building == null || _isEditing) {
            return ManagerBuildingForm(
              building: building,
              onCompleted: () {
                setState(() {
                  _isEditing = false;
                });
              },
            );
          }

          return ManagerBuildingDetails(
            building: building,
            onEdit: () {
              setState(() {
                _isEditing = true;
              });
            },
          );
        },
      ),
    );
  }
}
