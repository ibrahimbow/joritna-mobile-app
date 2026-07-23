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
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.all(10),
          child: Image.asset('assets/icons/app_icon.png', fit: BoxFit.contain),
        ),
        const SizedBox(height: 2),
        Text(
          isLogin ? 'Welcome' : 'Create your account',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AuthStyles.textDark,
          ),
        ),
        const SizedBox(height: 5),
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
