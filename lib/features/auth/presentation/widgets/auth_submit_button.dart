import 'package:flutter/material.dart';

import '../styles/auth_styles.dart';

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
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
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AuthStyles.officialBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
                isLogin ? 'Login' : 'Create account',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
