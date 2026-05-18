import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/stock_alert.dart';
import '../widgets/dashboard_middle_section.dart';
import '../widgets/recent_notebooks_table.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../core/theme/app_text_styles.dart';

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen general del sistema',
                  style: AppTextStyles.subtitle,
                ),

                const SizedBox(height: AppDimensions.sectionSpacing),

                ElevatedButton.icon(
                  onPressed: () => _mostrarMensajeDesarrollo(context),

                  icon: const Icon(Icons.download_rounded),

                  label: const Text('Exportar inventario CSV'),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.textOnDark,
                  ),
                ),
              ],
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
