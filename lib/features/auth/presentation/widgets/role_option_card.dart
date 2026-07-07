import 'package:flutter/material.dart';

import '../styles/auth_styles.dart';

class RoleOptionCard extends StatelessWidget {
  const RoleOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AuthStyles.officialBlue.withValues(alpha: 0.08)
              : AuthStyles.fieldBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AuthStyles.officialBlue : AuthStyles.border,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AuthStyles.officialBlue
                  : AuthStyles.textMuted,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? AuthStyles.officialBlue
                    : AuthStyles.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AuthStyles.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
