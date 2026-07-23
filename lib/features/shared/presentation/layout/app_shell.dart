import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/providers/notification_badge_provider.dart';
import '../../../../core/user/current_user_provider.dart';
import '../../../../core/user/user_role.dart';
import '../../../tenant/building/data/building_providers.dart';
import '../widgets/joritna_bottom_navigation_bar.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  final int selectedIndex;
  final Color backgroundColor;

  const AppShell({
    super.key,
    required this.child,
    required this.selectedIndex,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(currentUserProvider);
    final notificationBadgeState = ref.watch(notificationBadgeProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: child,
      bottomNavigationBar: currentUserState.when(
        loading: _buildNavigationPlaceholder,
        error: (_, __) => _buildNavigationPlaceholder(),
        data: (user) {
          if (user.role != UserRole.tenant) {
            return _buildNavigation(
              role: user.role,
              hasActiveBuildingMembership: true,
              announcementUnreadCount:
                  notificationBadgeState.announcementUnreadCount,
              chatUnreadCount: notificationBadgeState.chatUnreadCount,
              shareAndHelpUnreadCount:
                  notificationBadgeState.shareAndHelpUnreadCount,
            );
          }

          final buildingState = ref.watch(myBuildingProvider);

          return buildingState.when(
            loading: _buildNavigationPlaceholder,
            error: (_, __) => _buildNavigationPlaceholder(),
            data: (building) {
              return _buildNavigation(
                role: user.role,
                hasActiveBuildingMembership: true,
                announcementUnreadCount:
                    notificationBadgeState.announcementUnreadCount,
                chatUnreadCount: notificationBadgeState.chatUnreadCount,
                shareAndHelpUnreadCount:
                    notificationBadgeState.shareAndHelpUnreadCount,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNavigation({
    required UserRole role,
    required bool hasActiveBuildingMembership,
    required int announcementUnreadCount,
    required int chatUnreadCount,
    required int shareAndHelpUnreadCount,
  }) {
    return SafeArea(
      top: false,
      child: JoritnaBottomNavigationBar(
        selectedIndex: selectedIndex,
        role: role,
        hasActiveBuildingMembership: hasActiveBuildingMembership,
        announcementUnreadCount: announcementUnreadCount,
        chatUnreadCount: chatUnreadCount,
        shareAndHelpUnreadCount: shareAndHelpUnreadCount,
      ),
    );
  }

  Widget _buildNavigationPlaceholder() {
    return const SafeArea(top: false, child: SizedBox(height: 72));
  }
}
