import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'route_guards.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/auth/presentation/auth_mode.dart';
import '../../features/community/chat/presentation/chat_screen.dart';
import '../../features/community/share_and_help/data/models/share_and_help_post.dart';
import '../../features/community/share_and_help/presentation/create_post_screen.dart';
import '../../features/community/share_and_help/presentation/share_and_help_screen.dart';
import '../../features/manager/building/presentation/manager_building_screen.dart';
import '../../features/manager/dashboard/presentation/manager_dashboard_screen.dart';
import '../../features/manager/tenants/presentation/manager_tenants_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/tenant/announcements/presentation/announcements_screen.dart';
import '../../features/tenant/building/presentation/building_screen.dart';
import '../../features/tenant/dashboard/presentation/tenant_dashboard_screen.dart';
import '../../features/shared/presentation/settings/settings_screen.dart';
import '../../features/manager/announcements/data/models/manager_announcement.dart';
import '../../features/manager/announcements/presentation/manager_announcements_screen.dart';
import '../../features/manager/announcements/presentation/create_manager_announcement_screen.dart';
import '../../features/manager/announcements/presentation/edit_manager_announcement_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final isAuthenticated = await RouteGuards.isAuthenticated(ref);
      final currentRole = await RouteGuards.currentUserRole(ref);

      final location = state.matchedLocation;

      final isSplashRoute = location == AppRoutes.splash;
      final isLoginRoute = location == AppRoutes.login;
      final isRegisterRoute = location == AppRoutes.register;
      final isAuthRoute = isLoginRoute || isRegisterRoute;

      if (isSplashRoute) {
        return null;
      }

      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.dashboardForRole(currentRole ?? '');
      }

      if (AppRoutes.isTenantRoute(location) &&
          currentRole?.toUpperCase() != 'TENANT') {
        return AppRoutes.dashboardForRole(currentRole ?? '');
      }

      if (AppRoutes.isManagerRoute(location) &&
          currentRole?.toUpperCase() != 'MANAGER') {
        return AppRoutes.dashboardForRole(currentRole ?? '');
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
        builder: (context, state) {
          return const AuthScreen(initialMode: AuthMode.login);
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          return const AuthScreen(initialMode: AuthMode.register);
        },
      ),

      // Tenant routes
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

      // Manager routes
      GoRoute(
        path: AppRoutes.managerDashboard,
        builder: (context, state) => const ManagerDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerTenants,
        builder: (context, state) => const ManagerTenantsScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerBuilding,
        builder: (context, state) => const ManagerBuildingScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerAnnouncements,
        builder: (context, state) => const ManagerAnnouncementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerCreateAnnouncement,
        builder: (context, state) => const CreateManagerAnnouncementScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerEditAnnouncement,
        builder: (context, state) {
          final announcement = state.extra as ManagerAnnouncement;

          return EditManagerAnnouncementScreen(announcement: announcement);
        },
      ),
      GoRoute(
        path: AppRoutes.managerChat,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerShareAndHelp,
        builder: (context, state) => const ShareAndHelpScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerCreatePost,
        builder: (context, state) {
          final post = state.extra is ShareAndHelpPost
              ? state.extra as ShareAndHelpPost
              : null;

          return CreatePostScreen(postToEdit: post);
        },
      ),
      GoRoute(
        path: AppRoutes.managerSettings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Shared routes
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
