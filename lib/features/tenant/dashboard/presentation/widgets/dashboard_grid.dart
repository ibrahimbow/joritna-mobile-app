import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dashboard_card.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({super.key});

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
              DashboardCard(
                icon: Icons.apartment_rounded,
                title: 'Building',
                subtitle: 'View building info',
                backgroundColor: const Color(0xFFF3F1FF),
                iconColor: const Color(0xFF6366F1),
                onTap: () => context.go('/tenant/building'),
              ),
              DashboardCard(
                icon: Icons.campaign_rounded,
                title: 'Announcements',
                subtitle: 'Latest updates',
                backgroundColor: const Color(0xFFFFF4EB),
                iconColor: const Color(0xFFF97316),
                badgeCount: 3,
                onTap: () => context.go('/tenant/announcements'),
              ),
              DashboardCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Chat',
                subtitle: 'Chat with neighbors',
                backgroundColor: const Color(0xFFEEFBF2),
                iconColor: const Color(0xFF22C55E),
                badgeCount: 2,
                onTap: () => context.go('/tenant/chat'),
              ),
              DashboardCard(
                icon: Icons.volunteer_activism_rounded,
                title: 'Share & Help',
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
