import 'package:flutter/material.dart';

import 'router/routes.dart';

import '../core/session/inactivity_logout_wrapper.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../features/bodega/presentation/screens/bodega_home_screen.dart';
import '../features/tecnico/presentation/screens/tecnico_home_screen.dart';

import '../features/admin/presentation/screens/user_management_screen.dart';
import '../features/ventas/presentation/screens/ventas_home_screen.dart';
import '../features/reportes/presentation/screens/reportes_screen.dart';
import '../features/tecnico/presentation/screens/tecnico_reparacion_screen.dart';
import '../features/tecnico/presentation/screens/tecnico_disponible_screen.dart';
import '../features/tecnico/presentation/screens/tecnico_merma_screen.dart';
import '../features/tecnico/presentation/screens/tecnico_historial_screen.dart';
import '../features/admin/presentation/screens/system_events_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'ZTech',

      initialRoute: AppRoutes.login,

      routes: {
        AppRoutes.eventos: (context) => const SystemEventsScreen(),

        AppRoutes.login: (context) => const LoginScreen(),

        AppRoutes.dashboard: (context) => const AdminDashboardScreen(),

        AppRoutes.bodega: (context) => const BodegaHomeScreen(),

        AppRoutes.tecnico: (context) => const TecnicoHomeScreen(),

        AppRoutes.tecnicoReparacion: (context) =>
            const TecnicoReparacionScreen(),

        AppRoutes.tecnicoDisponible: (context) =>
            const TecnicoDisponiblesScreen(),

        AppRoutes.tecnicoMerma: (context) => const TecnicoMermaScreen(),

        AppRoutes.tecnicoHistorial: (context) => const TecnicoHistorialScreen(),

        AppRoutes.admin: (context) => const UserManagementScreen(),

        AppRoutes.ventas: (context) => const VentasHomeScreen(),

        AppRoutes.reportes: (context) => const ReportesScreen(),
      },

      builder: (context, child) {
        return InactivityLogoutWrapper(
          navigatorKey: navigatorKey,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
