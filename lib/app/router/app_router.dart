import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/community/chat/presentation/chat_screen.dart';
import '../../features/community/share_and_help/presentation/create_post_screen.dart';
import '../../features/community/share_and_help/presentation/share_and_help_screen.dart';
import '../../features/tenant/announcements/presentation/announcements_screen.dart';
import '../../features/tenant/building/presentation/building_screen.dart';
import '../../features/tenant/dashboard/presentation/tenant_dashboard_screen.dart';
import '../../features/tenant/settings/presentation/settings_screen.dart';
import 'app_routes.dart';
import 'route_guards.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final isAuthenticated = await RouteGuards.isAuthenticated(ref);

      final isSplashRoute = state.matchedLocation == AppRoutes.splash;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      if (isSplashRoute) {
        return null;
      }

      if (!isAuthenticated && !isLoginRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isLoginRoute) {
        return AppRoutes.tenantDashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenantDashboard,
        builder: (context, state) => const TenantDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenantBuilding,
        builder: (context, state) => const BuildingScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenantAnnouncements,
        builder: (context, state) => const AnnouncementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenantChat,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenantShareAndHelp,
        builder: (context, state) => const ShareAndHelpScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenantCreatePost,
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenantSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
