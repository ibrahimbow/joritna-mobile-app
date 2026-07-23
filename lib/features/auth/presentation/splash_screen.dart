import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/notifications/providers/notification_initializer_provider.dart';
import '../../../core/user/current_user_provider.dart';
import '../../../core/user/user_role.dart';
import '../data/auth_state_provider.dart';
import '../../../app/config/app_config.dart';
import '../../../core/storage/token_storage_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _minimumDisplayDuration = Duration(milliseconds: 1800);

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    Future<void>.microtask(_resolveStartupRoute);
  }

  Future<void> _resolveStartupRoute() async {
    final DateTime startedAt = DateTime.now();

    try {
      final bool isAuthenticated = await ref.read(authStateProvider.future);

      if (!isAuthenticated) {
        await _navigateAfterMinimumDuration(
          startedAt: startedAt,
          route: AppRoutes.login,
        );
        return;
      }

      final currentUser = await ref.read(currentUserProvider.future);

      await _initializeNotificationsSafely(userId: currentUser.id);

      final String targetRoute = switch (currentUser.role) {
        UserRole.manager => AppRoutes.managerDashboard,
        UserRole.tenant => AppRoutes.tenantDashboard,
        _ => AppRoutes.login,
      };

      await _navigateAfterMinimumDuration(
        startedAt: startedAt,
        route: targetRoute,
      );
    } catch (error, stackTrace) {
      debugPrint('Startup route resolution failed: $error');

      debugPrintStack(stackTrace: stackTrace);

      await _navigateAfterMinimumDuration(
        startedAt: startedAt,
        route: AppRoutes.login,
      );
    }
  }

  Future<void> _initializeNotificationsSafely({required int userId}) async {
    try {
      final String? accessToken = await ref
          .read(tokenStorageProvider)
          .getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint(
          'Notification initialization skipped: access token is unavailable.',
        );

        return;
      }

      await ref
          .read(notificationInitializerProvider)
          .initialize(
            userId: userId,
            socketUrl: '${AppConfig.webSocketBaseUrl}/ws/notifications',
            accessToken: accessToken,
          )
          .timeout(const Duration(seconds: 10));
    } catch (error, stackTrace) {
      debugPrint('Notification initialization failed: $error');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _navigateAfterMinimumDuration({
    required DateTime startedAt,
    required String route,
  }) async {
    final Duration elapsed = DateTime.now().difference(startedAt);
    final Duration remaining = _minimumDisplayDuration - elapsed;

    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }

    if (!mounted) {
      return;
    }

    context.go(route);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: const _SplashContent(),
                ),
              ),
            ),
            const Positioned(
              left: 24,
              right: 24,
              bottom: 28,
              child: _SplashFooter(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  static const Color _primaryBlue = Color(0xFF0057C8);
  static const Color _darkText = Color(0xFF0F172A);
  static const Color _mutedText = Color(0xFF64748B);

  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Joritna application loading',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/joritna_logo.png',
              width: 170,
              height: 170,
              fit: BoxFit.contain,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _primaryBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Image.asset(
                        'assets/icons/app_icon.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
            ),
            const SizedBox(height: 24),
            const Text(
              'JORITNA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _darkText,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 3.5,
                height: 1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Building Better Communities',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _mutedText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: _primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashFooter extends StatelessWidget {
  static const Color _mutedText = Color(0xFF64748B);

  const _SplashFooter();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Connecting neighbours. Building communities.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _mutedText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    );
  }
}
