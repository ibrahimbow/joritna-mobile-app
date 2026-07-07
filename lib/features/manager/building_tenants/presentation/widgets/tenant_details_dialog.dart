import 'package:flutter/material.dart';

import '../../data/models/manager_building_tenant.dart';

class TenantDetailsDialog extends StatelessWidget {
  const TenantDetailsDialog({
    super.key,
    required this.tenant,
    required this.onDelete,
  });

  final ManagerBuildingTenant tenant;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tenant details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _InfoRow(label: 'Name', value: tenant.username),
          _InfoRow(label: 'Phone', value: tenant.phoneNumber ?? '-'),
          _InfoRow(label: 'Email', value: tenant.email),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text('Remove'),
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
