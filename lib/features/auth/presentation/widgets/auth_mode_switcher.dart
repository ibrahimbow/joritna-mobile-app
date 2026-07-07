import 'package:flutter/material.dart';

import '../styles/auth_styles.dart';

class AuthModeSwitcher extends StatelessWidget {
  const AuthModeSwitcher({
    required this.isLogin,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final bool isLogin;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? 'New to Joritna?' : 'Already have an account?',
          style: const TextStyle(color: AuthStyles.textMuted),
        ),
        TextButton(
          onPressed: isLoading ? null : onPressed,
          child: Text(
            isLogin ? 'Create account' : 'Login',
            style: const TextStyle(
              color: AuthStyles.officialBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
