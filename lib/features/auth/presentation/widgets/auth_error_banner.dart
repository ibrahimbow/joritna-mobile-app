import 'package:flutter/material.dart';

class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({required this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: message == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  message!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
    );
  }
}
