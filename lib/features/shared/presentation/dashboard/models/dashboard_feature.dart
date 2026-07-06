import 'package:flutter/material.dart';

class DashboardFeature {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final int badgeCount;

  const DashboardFeature({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.badgeCount = 0,
  });
}
