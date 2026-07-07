class AppRoutes {
  const AppRoutes._();

  //--------------------------------------------------------------------------
  // Authentication
  //--------------------------------------------------------------------------

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';

  //--------------------------------------------------------------------------
  // Tenant
  //--------------------------------------------------------------------------

  static const tenantDashboard = '/tenant/dashboard';
  static const tenantBuilding = '/tenant/building';
  static const tenantAnnouncements = '/tenant/announcements';
  static const tenantChat = '/tenant/chat';
  static const tenantShareAndHelp = '/tenant/share-and-help';
  static const tenantCreatePost = '/tenant/share-and-help/create';
  static const tenantSettings = '/tenant/settings';

  //--------------------------------------------------------------------------
  // Manager
  //--------------------------------------------------------------------------

  static const managerDashboard = '/manager/dashboard';

  static const managerBuilding = '/manager/building';
  static const managerBuildings = '/manager/buildings';
  static const managerBuildingTenants = '/manager/building/tenants';

  static const managerAnnouncements = '/manager/announcements';
  static const managerCreateAnnouncement = '/manager/announcements/create';
  static const managerEditAnnouncement = '/manager/announcements/edit';

  static const managerChat = '/manager/chat';

  static const managerShareAndHelp = '/manager/share-and-help';
  static const managerCreatePost = '/manager/share-and-help/create';

  static const managerSettings = '/manager/settings';

  //--------------------------------------------------------------------------
  // Shared
  //--------------------------------------------------------------------------

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
