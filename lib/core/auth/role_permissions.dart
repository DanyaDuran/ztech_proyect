import '../../app/router/routes.dart';

class RolePermissions {
  static final Map<String, List<String>> permissions = {
    'superusuario': [AppRoutes.admin],
    'admin': [AppRoutes.dashboard, AppRoutes.reportes],
    'bodega': [AppRoutes.bodega],
    'tecnico': [AppRoutes.tecnico],
    'ventas': [AppRoutes.ventas],
  };

  static bool canAccess(String? role, String route) {
    if (role == null) return false;

    return permissions[role]?.contains(route) ?? false;
  }

  static String initialRouteForRole(String role) {
    switch (role) {
      case 'superusuario':
        return AppRoutes.admin;
      case 'admin':
        return AppRoutes.dashboard;
      case 'bodega':
        return AppRoutes.bodega;
      case 'tecnico':
        return AppRoutes.tecnico;
      case 'ventas':
        return AppRoutes.ventas;
      default:
        return AppRoutes.login;
    }
  }
}
