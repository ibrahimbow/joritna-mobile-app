import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_state_provider.dart';
import '../../../core/user/current_user_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_resolveStartupRoute);
  }

  Future<void> _resolveStartupRoute() async {
    try {
      final isAuthenticated = await ref.read(authStateProvider.future);

      if (!mounted) return;

      if (!isAuthenticated) {
        context.go('/login');
        return;
      }

      final currentUser = await ref.read(currentUserProvider.future);

      if (!mounted) return;

      final role = currentUser.role.name.toUpperCase();

      if (role == 'MANAGER') {
        context.go('/manager/dashboard');
        return;
      }

      if (role == 'TENANT') {
        context.go('/tenant/dashboard');
        return;
      }

      context.go('/login');
    } catch (_) {
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
