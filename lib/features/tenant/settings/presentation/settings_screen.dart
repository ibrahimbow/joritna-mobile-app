import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../auth/data/auth_providers.dart';
import '../../../shared/presentation/layout/app_shell.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(
                context,
                false,
              ),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(
                context,
                true,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(authRepositoryProvider).logout();

    if (!context.mounted) {
      return;
    }

    context.go(
      AppRoutes.login,
    );
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return AppShell(
      selectedIndex: 0,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            _SettingsTile(
              icon: Icons.person_outline_rounded,
              title: 'Profile',
              subtitle: 'Update your personal information',
              onTap: () {},
            ),

            _SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () {},
            ),

            _SettingsTile(
              icon: Icons.language_rounded,
              title: 'Language',
              subtitle: 'English',
              onTap: () {},
            ),

            _SettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () {},
            ),

            const SizedBox(height: 30),

            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => _logout(
                context,
                ref,
              ),
              icon: const Icon(Icons.logout),
              label: const Text(
                'Logout',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF0057C8),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.chevron_right_rounded,
        ),
        onTap: onTap,
      ),
    );
  }
}