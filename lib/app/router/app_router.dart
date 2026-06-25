import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';

import '../../features/tenant/dashboard/presentation/tenant_dashboard_screen.dart';

import '../../features/tenant/building/presentation/building_screen.dart';
import '../../features/tenant/announcements/presentation/announcements_screen.dart';
import '../../features/community/chat/presentation/chat_screen.dart';
import '../../features/community/share_and_help/presentation/share_and_help_screen.dart';
import '../../features/community/share_and_help/presentation/create_post_screen.dart';
import '../../features/tenant/settings/presentation/settings_screen.dart';



final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/tenant/dashboard',
        builder: (context, state) => const TenantDashboardScreen(),
      ),
      GoRoute(
        path: '/tenant/building',
        builder: (context, state) => const BuildingScreen(),
      ),
      GoRoute(
        path: '/tenant/announcements',
        builder: (context, state) => const AnnouncementsScreen(),
      ),
      GoRoute(
        path: '/tenant/chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/tenant/share-and-help',
        builder: (context, state) => const ShareAndHelpScreen(),
      ),
      GoRoute(
        path: '/tenant/share-and-help/create',
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: '/tenant/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});