import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joritna_mobile/core/user/user_role.dart';

import '../../../../core/user/current_user_provider.dart';
import '../../../shared/presentation/dashboard/widgets/dashboard_header.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../../building/data/manager_building_providers.dart';
import '../../building_tenants/data/manager_building_tenants_providers.dart';
import 'manager_dashboard_content.dart';

class ManagerDashboardScreen extends ConsumerWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(currentUserProvider);
    final buildingState = ref.watch(myManagedBuildingProvider);

    final totalTenants = buildingState.maybeWhen(
      data: (building) {
        if (building == null) {
          return 0;
        }

        final tenantsState = ref.watch(
          managerBuildingTenantsProvider(building.id),
        );

        return tenantsState.maybeWhen(
          data: (tenants) => tenants.length,
          orElse: () => 0,
        );
      },
      orElse: () => 0,
    );

    return AppShell(
      selectedIndex: 0,
      backgroundColor: ManagerDashboardTheme.primaryBlue,
      child: currentUserState.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
        error: (error, stackTrace) {
          debugPrint('MANAGER DASHBOARD USER ERROR: $error');
          debugPrint('MANAGER DASHBOARD USER STACKTRACE: $stackTrace');

          return const SafeArea(
            bottom: false,
            child: Column(
              children: [
                DashboardHeader(
                  displayName: 'Joritna Manager',
                  role: UserRole.manager,
                  avatarUrl: null,
                ),
                Expanded(child: ManagerDashboardContent(totalTenants: 0)),
              ],
            ),
          );
        },
        data: (user) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                DashboardHeader(
                  displayName: user.displayName,
                  role: user.role,
                  avatarUrl: user.avatarUrl,
                ),
                Expanded(
                  child: ManagerDashboardContent(totalTenants: totalTenants),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ManagerDashboardTheme {
  const ManagerDashboardTheme._();

  static const Color primaryBlue = Color(0xFF0057C8);
  static const Color deepBlue = Color(0xFF003B9E);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
}
