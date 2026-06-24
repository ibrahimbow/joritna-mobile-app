import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/current_user_provider.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../../../../app/router/app_routes.dart';

class DashboardTheme {
  const DashboardTheme._();

  static const Color primaryBlue = Color(0xFF0057C8);
  static const Color deepBlue = Color(0xFF003B9E);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
}

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

          return SafeArea(
            bottom: false,
            child: Column(
              children: const [
                _DashboardHeader(
                  displayName: 'Joritna User',
                  role: 'TENANT',
                  avatarUrl: null,
                ),
                Expanded(child: _DashboardBody()),
              ],
            ),
          );
        },
        data: (user) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                _DashboardHeader(
                  displayName: user.displayName,
                  role: user.role,
                  avatarUrl: user.avatarUrl,
                ),
                const Expanded(child: _DashboardBody()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String displayName;
  final String role;
  final String? avatarUrl;

  const _DashboardHeader({
    required this.displayName,
    required this.role,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isSmall = width < 380;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isSmall ? 20 : 24,
        20,
        isSmall ? 16 : 24,
        36,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [DashboardTheme.deepBlue, DashboardTheme.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            bottom: -30,
            child: Icon(
              Icons.apartment_rounded,
              size: 150,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: isSmall ? 38 : 46,
                backgroundColor: Colors.white,
                backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null || avatarUrl!.isEmpty
                    ? Icon(
                        Icons.person_rounded,
                        size: isSmall ? 40 : 48,
                        color: DashboardTheme.primaryBlue,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: isSmall ? 14 : 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmall ? 26 : 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        role.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.go(AppRoutes.tenantSettings),
                icon: const Icon(Icons.settings_rounded, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final horizontalPadding = width < 370 ? 18.0 : width * 0.06;
          final spacing = width < 370 ? 16.0 : 20.0;

          return GridView.count(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 32,
            ),
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: width < 370 ? 0.78 : 0.72,
            children: [
              _DashboardCard(
                icon: Icons.apartment_rounded,
                title: 'Building',
                subtitle: 'View building info',
                backgroundColor: const Color(0xFFF3F1FF),
                iconColor: const Color(0xFF6366F1),
                onTap: () => context.go('/tenant/building'),
              ),
              _DashboardCard(
                icon: Icons.campaign_rounded,
                title: 'Announcements',
                subtitle: 'Latest updates',
                backgroundColor: const Color(0xFFFFF4EB),
                iconColor: const Color(0xFFF97316),
                badgeCount: 3,
                onTap: () => context.go('/tenant/announcements'),
              ),
              _DashboardCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Chat',
                subtitle: 'Chat with manager',
                backgroundColor: const Color(0xFFEEFBF2),
                iconColor: const Color(0xFF22C55E),
                badgeCount: 2,
                onTap: () => context.go('/tenant/chat'),
              ),
              _DashboardCard(
                icon: Icons.volunteer_activism_rounded,
                title: 'Help / Share',
                subtitle: 'Help neighbors',
                backgroundColor: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF3B82F6),
                badgeCount: 1,
                onTap: () => context.go('/tenant/share-and-help'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color iconColor;
  final int? badgeCount;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Material(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 24, 14, 16),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    Container(
                      height: 64,
                      width: 64,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 30),
                    ),
                    const Spacer(flex: 2),
                    Text(
                      title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: DashboardTheme.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: DashboardTheme.textMuted,
                        fontSize: 12,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (badgeCount != null && badgeCount! > 0)
          Positioned(
            right: -6,
            top: 20,
            child: Container(
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
              decoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
