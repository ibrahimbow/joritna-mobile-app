import 'package:flutter/material.dart';

class TenantDeleteDialog extends StatelessWidget {
  const TenantDeleteDialog({super.key, required this.tenantName});

  final String tenantName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove tenant?'),
      content: Text(
        'Are you sure you want to remove $tenantName from this building?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Remove'),
        ),
      ],
    );
  }
}
