import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import 'dashboard_feature_card.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    super.key,
    this.isManager = false,
    this.includeBackground = true,
  });

  final bool isManager;
  final bool includeBackground;

  @override
  Widget build(BuildContext context) {
    final grid = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final horizontalPadding = width < 370 ? 18.0 : 22.0;
        final spacing = width < 370 ? 16.0 : 18.0;

        final childAspectRatio = height < 560
            ? 0.88
            : height < 640
            ? 0.84
            : 0.82;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: spacing + 14,
                crossAxisSpacing: spacing,
                childAspectRatio: childAspectRatio,
                children: [
                  DashboardCard(
                    icon: Icons.apartment_rounded,
                    title: 'Building',
                    subtitle: isManager
                        ? 'Manage building info'
                        : 'View building info',
                    backgroundColor: const Color(0xFFF3F1FF),
                    iconColor: const Color(0xFF6366F1),
                    onTap: () => context.go(
                      isManager
                          ? AppRoutes.managerBuilding
                          : AppRoutes.tenantBuilding,
                    ),
                  ),
                  DashboardCard(
                    icon: Icons.campaign_rounded,
                    title: 'Announcements',
                    subtitle: isManager ? 'Manage updates' : 'Latest updates',
                    backgroundColor: const Color(0xFFFFF4EB),
                    iconColor: const Color(0xFFF97316),
                    badgeCount: 3,
                    onTap: () => context.go(
                      isManager
                          ? AppRoutes.managerAnnouncements
                          : AppRoutes.tenantAnnouncements,
                    ),
                  ),
                  DashboardCard(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Chat',
                    subtitle: isManager
                        ? 'Chat with residents'
                        : 'Chat with neighbors',
                    backgroundColor: const Color(0xFFEEFBF2),
                    iconColor: const Color(0xFF22C55E),
                    badgeCount: 2,
                    onTap: () => context.go(
                      isManager ? AppRoutes.managerChat : AppRoutes.tenantChat,
                    ),
                  ),
                  DashboardCard(
                    icon: Icons.volunteer_activism_rounded,
                    title: 'Share & Help',
                    subtitle: isManager
                        ? 'Support your community'
                        : 'Help neighbors',
                    backgroundColor: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF3B82F6),
                    badgeCount: 1,
                    onTap: () => context.go(
                      isManager
                          ? AppRoutes.managerShareAndHelp
                          : AppRoutes.tenantShareAndHelp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!includeBackground) {
      return grid;
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: grid,
    );
  }
}
