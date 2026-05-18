import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  void _descargarReporte(BuildContext context, String nombre) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descargando CSV de $nombre...'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SidebarMenu(currentRoute: '/reportes'),
      appBar: const CustomAppBar(title: 'Reportes'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exportación de reportes',
              style: AppTextStyles.sectionTitle,
            ),

            const SizedBox(height: 8),

            const Text(
              'Selecciona el módulo del cual deseas descargar información en formato CSV.',
              style: AppTextStyles.subtitle,
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            _ReportCard(
              icon: Icons.inventory_2_outlined,
              title: 'Reporte de Bodega',
              description:
                  'Incluye notebooks registrados, estado actual, ubicación física y fecha de ingreso.',
              buttonText: 'Descargar CSV Bodega',
              onPressed: () => _descargarReporte(context, 'Bodega'),
            ),

            _ReportCard(
              icon: Icons.build_circle_outlined,
              title: 'Reporte Técnico',
              description:
                  'Incluye cambios de estado, diagnóstico técnico, acciones realizadas y fecha.',
              buttonText: 'Descargar CSV Técnico',
              onPressed: () => _descargarReporte(context, 'Técnico'),
            ),

            _ReportCard(
              icon: Icons.point_of_sale_outlined,
              title: 'Reporte de Ventas',
              description:
                  'Incluye ventas registradas, cliente, equipo vendido, precio, forma de pago y fecha.',
              buttonText: 'Descargar CSV Ventas',
              onPressed: () => _descargarReporte(context, 'Ventas'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const _ReportCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: AppDimensions.cardElevation,
      margin: const EdgeInsets.only(bottom: AppDimensions.inputSpacing),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 30),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(description, style: AppTextStyles.body),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.download_rounded),
                label: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
