import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/tenant_dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/tenant/dashboard',
      builder: (context, state) {
        return const TenantDashboardScreen();
      },
    ),
  ],
);