import 'package:flutter/material.dart';

import 'router/routes.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../features/bodega/presentation/screens/bodega_home_screen.dart';
import '../features/tecnico/presentation/screens/tecnico_home_screen.dart';

import '../features/admin/presentation/screens/user_management_screen.dart';
import '../features/ventas/presentation/screens/ventas_home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZTech',
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.dashboard: (context) => const AdminDashboardScreen(),
        AppRoutes.bodega: (context) => const BodegaHomeScreen(),
        AppRoutes.tecnico: (context) => const TecnicoHomeScreen(),
        AppRoutes.admin: (context) => const UserManagementScreen(),
        AppRoutes.ventas: (context) => const VentasHomeScreen(),
      },
    );
  }
}
