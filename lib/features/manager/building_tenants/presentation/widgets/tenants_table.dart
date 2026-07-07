import 'package:flutter/material.dart';

import '../../data/models/manager_building_tenant.dart';
import 'tenant_table_row.dart';

class TenantsTable extends StatelessWidget {
  const TenantsTable({
    super.key,
    required this.tenants,
    required this.removingTenantUserId,
    required this.onRemoveTenant,
    required this.onOpenTenantDetails,
  });

  final List<ManagerBuildingTenant> tenants;
  final int? removingTenantUserId;
  final void Function(ManagerBuildingTenant tenant) onRemoveTenant;
  final void Function(ManagerBuildingTenant tenant) onOpenTenantDetails;

  @override
  Widget build(BuildContext context) {
    const columnWidths = <int, TableColumnWidth>{
      0: FlexColumnWidth(2.15), // Name
      1: FlexColumnWidth(1.85), // Phone
      2: FlexColumnWidth(2.45), // Email
      3: FixedColumnWidth(62), // Action
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Table(
          columnWidths: columnWidths,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xFFF8FAFC)),
              children: [
                _HeaderCell(label: 'Name'),
                _HeaderCell(label: 'Phone'),
                _HeaderCell(label: 'Email'),
                _HeaderCell(label: 'Action'),
              ],
            ),
            ...tenants.indexed.map((entry) {
              final index = entry.$1;
              final tenant = entry.$2;

              return tenantTableRowBuilder(
                index: index,
                tenant: tenant,
                isRemoving: removingTenantUserId == tenant.tenantUserId,
                onRemove: () => onRemoveTenant(tenant),
                onOpenDetails: () => onOpenTenantDetails(tenant),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Color(0xFF0057C8),
        ),
      ),
    );
  }
}
