import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/user/user_role.dart';

class JoritnaBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final UserRole role;

  const JoritnaBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.role,
  });

  static const Color primaryBlue = Color(0xFF0057C8);
  static const Color mutedText = Color(0xFF64748B);

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
    ),
    _BottomNavigationDestination(
      icon: Icons.chat_bubble_outline_rounded,
      label: 'Chat',
      route: AppRoutes.managerChat,
    ),
    _BottomNavigationDestination(
      icon: Icons.volunteer_activism_rounded,
      label: 'Help',
      route: AppRoutes.managerShareAndHelp,
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
    ),
    _BottomNavigationDestination(
      icon: Icons.chat_bubble_outline_rounded,
      label: 'Chat',
      route: AppRoutes.tenantChat,
    ),
    _BottomNavigationDestination(
      icon: Icons.volunteer_activism_rounded,
      label: 'Help',
      route: AppRoutes.tenantShareAndHelp,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = _itemsForRole(role);

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
            onTap: () {
              if (selectedIndex == index) return;
              context.go(item.route);
            },
          );
        }),
      ),
    );
  }

  List<_BottomNavigationDestination> _itemsForRole(UserRole role) {
    switch (role) {
      case UserRole.manager:
      case UserRole.admin:
        return _managerItems;
      case UserRole.tenant:
        return _tenantItems;
    }
  }
}

class _BottomNavigationDestination {
  final IconData icon;
  final String label;
  final String route;

  const _BottomNavigationDestination({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? JoritnaBottomNavigationBar.primaryBlue
        : JoritnaBottomNavigationBar.mutedText;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFE6EFFD) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
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
    );
  }
}
