import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';

class JoritnaBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const JoritnaBottomNavigationBar({super.key, required this.selectedIndex});

  static const Color primaryBlue = Color(0xFF0057C8);
  static const Color mutedText = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.04)),
        ),
      ),
      child: Row(
        children: [
          _BottomNavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            selected: selectedIndex == 0,
            onTap: () => context.go(AppRoutes.tenantDashboard),
          ),

          _BottomNavItem(
            icon: Icons.apartment_rounded,
            label: 'Building',
            selected: selectedIndex == 1,
            onTap: () => context.go(AppRoutes.tenantBuilding),
          ),

          _BottomNavItem(
            icon: Icons.add_circle_rounded,
            label: 'Add Post',
            selected: selectedIndex == 2,
            onTap: () => context.go(AppRoutes.tenantCreatePost),
          ),

          _BottomNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat',
            selected: selectedIndex == 3,
            onTap: () => context.go(AppRoutes.tenantChat),
          ),

          _BottomNavItem(
            icon: Icons.volunteer_activism_rounded,
            label: 'Help',
            selected: selectedIndex == 4,
            onTap: () => context.go(AppRoutes.tenantShareAndHelp),
          ),
        ],
      ),
    );
  }
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                fontSize: 11,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
