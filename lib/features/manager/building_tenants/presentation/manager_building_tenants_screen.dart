import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';

import '../../../../core/errors/api_failure.dart';
import '../../building/data/manager_building_providers.dart';
import '../data/manager_building_tenants_providers.dart';
import '../data/models/manager_building_tenant.dart';
import 'widgets/tenant_delete_dialog.dart';
import 'widgets/tenant_details_dialog.dart';
import 'widgets/tenants_empty_state.dart';
import 'widgets/tenants_header.dart';
import 'widgets/tenants_loading.dart';
import 'widgets/tenants_summary_card.dart';
import 'widgets/tenants_table.dart';

class ManagerBuildingTenantsScreen extends ConsumerStatefulWidget {
  const ManagerBuildingTenantsScreen({super.key, required this.buildingId});

  final String? buildingId;

  @override
  ConsumerState<ManagerBuildingTenantsScreen> createState() =>
      _ManagerBuildingTenantsScreenState();
}

class _ManagerBuildingTenantsScreenState
    extends ConsumerState<ManagerBuildingTenantsScreen> {
  int? _removingTenantUserId;

  @override
  Widget build(BuildContext context) {
    final managerBuildingState = ref.watch(myManagedBuildingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: managerBuildingState.when(
        loading: () => const TenantsLoading(),
        error: (_, __) => _PageLayout(
          onBack: () => context.go(AppRoutes.managerDashboard),
          children: const [TenantsEmptyState()],
        ),
        data: (building) {
          final resolvedBuildingId = widget.buildingId ?? building?.id;

          if (resolvedBuildingId == null || resolvedBuildingId.isEmpty) {
            return _PageLayout(
              onBack: () => context.go(AppRoutes.managerDashboard),
              children: const [TenantsEmptyState()],
            );
          }

          final tenantsState = ref.watch(
            managerBuildingTenantsProvider(resolvedBuildingId),
          );

          return _PageLayout(
            onBack: () => context.go(AppRoutes.managerDashboard),
            onRefresh: () async {
              ref.invalidate(
                managerBuildingTenantsProvider(resolvedBuildingId),
              );
            },
            children: [
              TenantsSummaryCard(
                buildingName: building?.buildingName ?? 'Your building',
                address: building?.address ?? 'No address available',
              ),
              const SizedBox(height: 22),
              tenantsState.when(
                loading: () => const TenantsLoading(),
                error: (_, __) => _ErrorCard(
                  onRetry: () {
                    ref.invalidate(
                      managerBuildingTenantsProvider(resolvedBuildingId),
                    );
                  },
                ),
                data: (tenants) {
                  if (tenants.isEmpty) {
                    return const TenantsEmptyState();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TenantsToolbar(
                        totalTenants: tenants.length,
                        onRefresh: () {
                          ref.invalidate(
                            managerBuildingTenantsProvider(resolvedBuildingId),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      TenantsTable(
                        tenants: tenants,
                        removingTenantUserId: _removingTenantUserId,
                        onRemoveTenant: (tenant) {
                          _confirmAndRemoveTenant(
                            buildingId: resolvedBuildingId,
                            tenant: tenant,
                          );
                        },
                        onOpenTenantDetails: (tenant) {
                          _showTenantDetails(
                            buildingId: resolvedBuildingId,
                            tenant: tenant,
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      const _InfoCard(),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showTenantDetails({
    required String buildingId,
    required ManagerBuildingTenant tenant,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return TenantDetailsDialog(
          tenant: tenant,
          onDelete: () {
            _confirmAndRemoveTenant(buildingId: buildingId, tenant: tenant);
          },
        );
      },
    );
  }

  Future<void> _confirmAndRemoveTenant({
    required String buildingId,
    required ManagerBuildingTenant tenant,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => TenantDeleteDialog(tenantName: tenant.username),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _removingTenantUserId = tenant.tenantUserId;
    });

    try {
      await ref
          .read(managerBuildingTenantsRepositoryProvider)
          .removeTenantFromBuilding(
            buildingId: buildingId,
            tenantUserId: tenant.tenantUserId,
          );

      ref.invalidate(managerBuildingTenantsProvider(buildingId));

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tenant removed successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on ApiFailure catch (failure) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to remove tenant. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _removingTenantUserId = null;
        });
      }
    }
  }
}

class _PageLayout extends StatelessWidget {
  const _PageLayout({
    required this.onBack,
    required this.children,
    this.onRefresh,
  });

  final VoidCallback onBack;
  final List<Widget> children;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TenantsHeader(onBack: onBack),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh ?? () async {},
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 32),
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

class _TenantsToolbar extends StatelessWidget {
  const _TenantsToolbar({required this.totalTenants, required this.onRefresh});

  final int totalTenants;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Total Tenants: $totalTenants',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Refresh'),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBD7FF)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, color: Color(0xFF0057C8), size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Removing a tenant will remove their access to this building and all associated tenant features.',
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0057C8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, size: 46, color: Colors.red),
          const SizedBox(height: 14),
          const Text(
            'Could not load tenants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
