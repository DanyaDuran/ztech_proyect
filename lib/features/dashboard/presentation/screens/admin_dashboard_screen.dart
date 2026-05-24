import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';
import 'package:ztech_flutter__app/shared/widgets/app_bar/custom_app_bar.dart';
import 'package:ztech_flutter__app/shared/widgets/sidebar/sidebar_menu.dart';
import 'package:ztech_flutter__app/features/dashboard/presentation/widgets/widgets.dart';
import 'package:ztech_flutter__app/features/reportes/presentation/screens/reportes_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _mostrarMensajeDesarrollo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad en desarrollo (Próximo Sprint)'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  void _irAReportes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SidebarMenu(currentRoute: '/dashboard'),
      appBar: const CustomAppBar(title: 'Dashboard'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Resumen general del sistema',
              style: AppTextStyles.subtitle,
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            ElevatedButton.icon(
              onPressed: () => _irAReportes(context),
              icon: const Icon(Icons.download_rounded),
              label: const Text('Ir a reportes CSV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.textOnDark,
              ),
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            const DashboardStats(),

            StockAlert(onShowMessage: () => _mostrarMensajeDesarrollo(context)),

            const SizedBox(height: AppDimensions.sectionSpacing),

            DashboardMiddleSection(
              onShowMessage: () => _mostrarMensajeDesarrollo(context),
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            const RecentNotebooksTable(),

            const SizedBox(height: AppDimensions.sectionSpacing),
          ],
        ),
      ),
    );
  }
}
