import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/data/current_user_provider.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import 'widgets/dashboard_grid.dart';
import 'widgets/dashboard_header.dart';

class TenantDashboardScreen extends ConsumerWidget {
  const TenantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(currentUserProvider);

    return AppShell(
      selectedIndex: 0,
      backgroundColor: DashboardTheme.primaryBlue,
      child: currentUserState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (error, stackTrace) {
          debugPrint('DASHBOARD USER ERROR: $error');
          debugPrint('DASHBOARD USER STACKTRACE: $stackTrace');

          return const SafeArea(
            bottom: false,
            child: Column(
              children: [
                DashboardHeader(
                  displayName: 'Joritna User',
                  role: 'TENANT',
                  avatarUrl: null,
                ),
                Expanded(child: DashboardGrid()),
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
                const Expanded(child: DashboardGrid()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DashboardTheme {
  const DashboardTheme._();

  static const Color primaryBlue = Color(0xFF0057C8);
  static const Color deepBlue = Color(0xFF003B9E);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
}
