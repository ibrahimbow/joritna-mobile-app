class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';

  static const tenantDashboard = '/tenant/dashboard';
  static const tenantBuilding = '/tenant/building';
  static const tenantAnnouncements = '/tenant/announcements';
  static const tenantChat = '/tenant/chat';
  static const tenantShareAndHelp = '/tenant/share-and-help';
  static const tenantCreatePost = '/tenant/share-and-help/create';
  static const tenantSettings = '/tenant/settings';

  static const managerDashboard = '/manager/dashboard';
  static const managerTenants = '/manager/tenants';
  static const managerBuilding = '/manager/building';
  static const managerAnnouncements = '/manager/announcements';
  static const managerChat = '/manager/chat';
  static const managerShareAndHelp = '/manager/share-and-help';
  static const managerCreatePost = '/manager/share-and-help/create';
  static const managerSettings = '/manager/settings';

  static const profile = '/profile';

  static bool isTenantRoute(String location) {
    return location.startsWith('/tenant');
  }

  static bool isManagerRoute(String location) {
    return location.startsWith('/manager');
  }

  static String dashboardForRole(String role) {
    return switch (role.toUpperCase()) {
      'MANAGER' => managerDashboard,
      'TENANT' => tenantDashboard,
      _ => login,
    };
  }
}
