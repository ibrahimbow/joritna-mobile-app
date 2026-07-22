import 'package:flutter/material.dart';

import '../styles/auth_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.isLogin, super.key});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AuthStyles.officialBlue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(
            Icons.apartment_rounded,
            color: AuthStyles.officialBlue,
            size: 36,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          isLogin ? 'Welcome' : 'Create your account',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AuthStyles.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isLogin
              ? 'Login to continue to Joritna'
              : 'Choose your role and join Joritna',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AuthStyles.textMuted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
