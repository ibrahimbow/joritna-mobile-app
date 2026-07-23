import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/user/user_role.dart';

class JoritnaBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final UserRole role;
  final bool hasActiveBuildingMembership;
  final int announcementUnreadCount;
  final int chatUnreadCount;
  final int shareAndHelpUnreadCount;

  const JoritnaBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.role,
    required this.hasActiveBuildingMembership,
    this.announcementUnreadCount = 0,
    this.chatUnreadCount = 0,
    this.shareAndHelpUnreadCount = 0,
  });

  static const Color primaryBlue = Color(0xFF0057C8);
  static const Color mutedText = Color(0xFF64748B);
  static const Color badgeColor = Color(0xFFE53935);

  static const List<_BottomNavigationDestination> _managerItems = [
    _BottomNavigationDestination(
      icon: Icons.home_rounded,
      label: 'Home',
      route: AppRoutes.managerDashboard,
    ),
    _BottomNavigationDestination(
      icon: Icons.apartment_rounded,
      label: 'Building',
      route: AppRoutes.managerBuilding,
    ),
    _BottomNavigationDestination(
      icon: Icons.campaign_rounded,
      label: 'Announce',
      route: AppRoutes.managerAnnouncements,
      badgeType: _NavigationBadgeType.announcement,
    ),
    _BottomNavigationDestination(
      icon: Icons.chat_bubble_outline_rounded,
      label: 'Chat',
      route: AppRoutes.managerChat,
      badgeType: _NavigationBadgeType.chat,
    ),
    _BottomNavigationDestination(
      icon: Icons.diversity_3_rounded,
      label: 'Help',
      route: AppRoutes.managerShareAndHelp,
      badgeType: _NavigationBadgeType.shareAndHelp,
    ),
  ];

  static const List<_BottomNavigationDestination> _tenantItems = [
    _BottomNavigationDestination(
      icon: Icons.home_rounded,
      label: 'Home',
      route: AppRoutes.tenantDashboard,
    ),
    _BottomNavigationDestination(
      icon: Icons.apartment_rounded,
      label: 'Building',
      route: AppRoutes.tenantBuilding,
    ),
    _BottomNavigationDestination(
      icon: Icons.campaign_rounded,
      label: 'Announce',
      route: AppRoutes.tenantAnnouncements,
      badgeType: _NavigationBadgeType.announcement,
    ),
    _BottomNavigationDestination(
      icon: Icons.chat_bubble_outline_rounded,
      label: 'Chat',
      route: AppRoutes.tenantChat,
      badgeType: _NavigationBadgeType.chat,
    ),
    _BottomNavigationDestination(
      icon: Icons.diversity_3_rounded,
      label: 'Share & Help',
      route: AppRoutes.tenantShareAndHelp,
      badgeType: _NavigationBadgeType.shareAndHelp,
    ),
  ];

  static const List<_BottomNavigationDestination> _tenantWithoutBuildingItems =
      [
        _BottomNavigationDestination(
          icon: Icons.apartment_rounded,
          label: 'Join Building',
          route: AppRoutes.tenantBuilding,
        ),
        _BottomNavigationDestination(
          icon: Icons.settings_rounded,
          label: 'Settings',
          route: AppRoutes.tenantSettings,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final items = _itemsForUser();

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.04)),
        ),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];

          return _BottomNavItem(
            icon: item.icon,
            label: item.label,
            selected: selectedIndex == index,
            unreadCount: _unreadCountFor(item.badgeType),
            onTap: () {
              if (selectedIndex == index) {
                return;
              }

              context.go(item.route);
            },
          );
        }),
      ),
    );
  }

  List<_BottomNavigationDestination> _itemsForUser() {
    switch (role) {
      case UserRole.manager:
      case UserRole.admin:
        return _managerItems;

      case UserRole.tenant:
        if (!hasActiveBuildingMembership) {
          return _tenantWithoutBuildingItems;
        }

        return _tenantItems;
    }
  }

  int _unreadCountFor(_NavigationBadgeType badgeType) {
    switch (badgeType) {
      case _NavigationBadgeType.none:
        return 0;

      case _NavigationBadgeType.announcement:
        return announcementUnreadCount;

      case _NavigationBadgeType.chat:
        return chatUnreadCount;

      case _NavigationBadgeType.shareAndHelp:
        return shareAndHelpUnreadCount;
    }
  }
}

enum _NavigationBadgeType { none, announcement, chat, shareAndHelp }

class _BottomNavigationDestination {
  final IconData icon;
  final String label;
  final String route;
  final _NavigationBadgeType badgeType;

  const _BottomNavigationDestination({
    required this.icon,
    required this.label,
    required this.route,
    this.badgeType = _NavigationBadgeType.none,
  });
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final int unreadCount;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? JoritnaBottomNavigationBar.primaryBlue
        : JoritnaBottomNavigationBar.mutedText;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: _semanticLabel,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFE6EFFD)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _NavigationIconWithBadge(
                  icon: icon,
                  color: color,
                  unreadCount: unreadCount,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _semanticLabel {
    if (unreadCount <= 0) {
      return label;
    }

    return '$label, $unreadCount unread notifications';
  }
}

class _NavigationIconWithBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int unreadCount;

  const _NavigationIconWithBadge({
    required this.icon,
    required this.color,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: color, size: 24),
        if (unreadCount > 0)
          Positioned(
            top: -8,
            right: -12,
            child: _UnreadBadge(unreadCount: unreadCount),
          ),
      ],
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int unreadCount;

  const _UnreadBadge({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    final badgeText = unreadCount > 9 ? '9+' : unreadCount.toString();

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: JoritnaBottomNavigationBar.badgeColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        badgeText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
