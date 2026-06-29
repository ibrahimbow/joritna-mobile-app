import 'package:flutter/material.dart';

import '../../../../../core/realtime/realtime_connection_status.dart';

class ChatConnectionStatusChip extends StatelessWidget {
  const ChatConnectionStatusChip({super.key, required this.status});

  final RealtimeConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final _StatusUi ui = switch (status) {
      RealtimeConnectionStatus.connected => _StatusUi(
        icon: Icons.circle,
        color: Colors.green,
        label: 'Connected',
      ),
      RealtimeConnectionStatus.connecting => _StatusUi(
        icon: Icons.sync,
        color: Colors.orange,
        label: 'Connecting',
      ),
      RealtimeConnectionStatus.reconnecting => _StatusUi(
        icon: Icons.sync,
        color: Colors.orange,
        label: 'Reconnecting',
      ),
      RealtimeConnectionStatus.failed => _StatusUi(
        icon: Icons.error_outline,
        color: theme.colorScheme.error,
        label: 'Offline',
      ),
      RealtimeConnectionStatus.disconnected => _StatusUi(
        icon: Icons.circle_outlined,
        color: theme.colorScheme.outline,
        label: 'Disconnected',
      ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ui.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ui.icon, size: 10, color: ui.color),
          const SizedBox(width: 6),
          Text(
            ui.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: ui.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusUi {
  const _StatusUi({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;
}
