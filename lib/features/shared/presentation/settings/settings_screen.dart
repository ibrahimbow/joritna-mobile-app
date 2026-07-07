import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../auth/data/auth_providers.dart';
import '../../../auth/data/auth_state_provider.dart';
import '../../../community/chat/data/chat_providers.dart';
import '../../../profile/data/profile_providers.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../../../tenant/building/data/building_providers.dart';
import '../../../../core/user/current_user_provider.dart';
import '../../../../core/user/user_role.dart';
import 'widgets/change_password_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
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

    ref.invalidate(authStateProvider);
    ref.invalidate(profileProvider);
    ref.invalidate(myBuildingProvider);
    ref.invalidate(chatStateNotifierProvider);
    ref.invalidate(currentUserProvider);

    if (!context.mounted) {
      return;
    }

    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(currentUserProvider);
    final buildingState = ref.watch(myBuildingProvider);

    return currentUserState.when(
      loading: () => const Scaffold(
        body: SafeArea(
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => Scaffold(
        body: _SettingsContent(
          showJoinBuildingButton: false,
          onLogout: () => _logout(context, ref),
        ),
      ),
      data: (currentUser) {
        final isTenant = currentUser.role == UserRole.tenant;
        final shouldShowJoinBuildingButton =
            isTenant && buildingState.hasError;

        final content = _SettingsContent(
          showJoinBuildingButton: shouldShowJoinBuildingButton,
          onLogout: () => _logout(context, ref),
        );

        return AppShell(
          selectedIndex: 0,
          child: content,
        );
      },
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent({
    required this.showJoinBuildingButton,
    required this.onLogout,
  });

  final bool showJoinBuildingButton;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _SettingsTile(
            icon: Icons.person_outline_rounded,
            title: 'Profile',
            subtitle: 'Update your personal information',
            onTap: () => context.push(AppRoutes.profile),
          ),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => const ChangePasswordSheet(),
              );
            },
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
          if (showJoinBuildingButton) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => context.go(AppRoutes.tenantBuilding),
              icon: const Icon(Icons.apartment_rounded),
              label: const Text('Join Building'),
            ),
            const SizedBox(height: 20),
          ],
          const SizedBox(height: 30),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0057C8)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}