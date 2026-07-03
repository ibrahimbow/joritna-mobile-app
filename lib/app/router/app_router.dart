import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/community/chat/presentation/chat_screen.dart';
import '../../features/community/share_and_help/data/models/share_and_help_post.dart';
import '../../features/community/share_and_help/presentation/create_post_screen.dart';
import '../../features/community/share_and_help/presentation/share_and_help_screen.dart';
import '../../features/tenant/announcements/presentation/announcements_screen.dart';
import '../../features/tenant/building/presentation/building_screen.dart';
import '../../features/tenant/dashboard/presentation/tenant_dashboard_screen.dart';
import '../../features/tenant/settings/presentation/settings_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import 'app_routes.dart';
import 'route_guards.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final isAuthenticated = await RouteGuards.isAuthenticated(ref);

      final isSplashRoute = state.matchedLocation == AppRoutes.splash;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;
      final isRegisterRoute = state.matchedLocation == AppRoutes.register;

      if (isSplashRoute) {
        return null;
      }

      if (!isAuthenticated && !isLoginRoute && !isRegisterRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated && (isLoginRoute || isRegisterRoute)) {
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
        builder: (context, state) =>
            const AuthScreen(initialMode: AuthMode.login),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) =>
            const AuthScreen(initialMode: AuthMode.register),
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
        builder: (context, state) {
          final post = state.extra is ShareAndHelpPost
              ? state.extra as ShareAndHelpPost
              : null;

          return CreatePostScreen(postToEdit: post);
        },
      ),
      GoRoute(
        path: AppRoutes.tenantSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
