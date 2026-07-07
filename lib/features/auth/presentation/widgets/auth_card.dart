import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({required this.modeKey, required this.child, super.key});

  final Object modeKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(modeKey),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
