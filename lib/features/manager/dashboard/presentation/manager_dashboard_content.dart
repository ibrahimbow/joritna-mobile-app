import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../shared/presentation/dashboard/widgets/dashboard_grid.dart';
import 'widgets/manager_tenants_banner.dart';

class ManagerDashboardContent extends StatelessWidget {
  const ManagerDashboardContent({super.key, required this.totalTenants});

  final int totalTenants;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          ManagerTenantsBanner(
            totalTenants: totalTenants,
            onTap: () => context.go(AppRoutes.managerBuildingTenants),
          ),
          const Expanded(child: DashboardGrid(isManager: true)),
        ],
      ),
    );
  }
}
