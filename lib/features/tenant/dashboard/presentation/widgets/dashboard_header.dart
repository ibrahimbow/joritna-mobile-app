import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../../../core/file/file_url_resolver.dart';
import '../../../../profile/data/profile_providers.dart';
import '../tenant_dashboard_screen.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    super.key,
    required this.displayName,
    required this.role,
    required this.avatarUrl,
    this.showSettingsButton = true,
  });

  final String displayName;
  final String role;
  final String? avatarUrl;
  final bool showSettingsButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    final freshDisplayName = profileState.maybeWhen(
      data: (profile) => profile.displayName,
      orElse: () => displayName,
    );

    final freshAvatarUrl = profileState.maybeWhen(
      data: (profile) => profile.avatarUrl,
      orElse: () => avatarUrl,
    );

    final width = MediaQuery.sizeOf(context).width;
    final isSmall = width < 380;

    final safeDisplayName = freshDisplayName.trim().isEmpty
        ? 'Resident'
        : freshDisplayName.trim();

    final resolvedAvatarUrl = FileUrlResolver.resolve(freshAvatarUrl);

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
              _DashboardAvatar(
                avatarUrl: resolvedAvatarUrl,
                displayName: safeDisplayName,
                radius: isSmall ? 38 : 46,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome,',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: isSmall ? 14 : 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      safeDisplayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmall ? 26 : 32,
                        fontWeight: FontWeight.w800,
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
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
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
              if (showSettingsButton)
                IconButton(
                  tooltip: 'Settings',
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

class _DashboardAvatar extends StatelessWidget {
  const _DashboardAvatar({
    required this.avatarUrl,
    required this.displayName,
    required this.radius,
  });

  final String avatarUrl;
  final String displayName;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initials = displayName.isNotEmpty
        ? displayName.substring(0, 1).toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFE2E7FF),
        backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
        child: avatarUrl.isEmpty
            ? Text(
                initials,
                style: TextStyle(
                  color: DashboardTheme.primaryBlue,
                  fontSize: radius * 0.75,
                  fontWeight: FontWeight.w800,
                ),
              )
            : null,
      ),
    );
  }
}
