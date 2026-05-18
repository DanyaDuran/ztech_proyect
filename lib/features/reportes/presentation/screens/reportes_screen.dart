import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      drawer: const SidebarMenu(currentRoute: '/reportes'),

      appBar: const CustomAppBar(title: 'Reportes'),

      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),

        child: Center(
          child: Container(
            width: 500,

            padding: const EdgeInsets.all(AppDimensions.screenPadding),

            decoration: BoxDecoration(
              color: AppColors.surface,

              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),

              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  size: 72,
                  color: AppColors.primary,
                ),

                const SizedBox(height: AppDimensions.sectionSpacing),

                const Text(
                  'Módulo de reportes',
                  style: AppTextStyles.sectionTitle,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Esta sección será desarrollada en próximos sprints.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),

                const SizedBox(height: AppDimensions.sectionSpacing),

                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad en desarrollo'),
                      ),
                    );
                  },

                  icon: const Icon(Icons.analytics_outlined),

                  label: const Text('Generar reporte'),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnDark,
                    elevation: 0,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
