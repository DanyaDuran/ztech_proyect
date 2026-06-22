import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ztech_flutter__app/core/theme/app_colors.dart';
import 'package:ztech_flutter__app/core/theme/app_dimensions.dart';
import 'package:ztech_flutter__app/core/theme/app_text_styles.dart';
import 'package:ztech_flutter__app/shared/widgets/app_bar/custom_app_bar.dart';
import 'package:ztech_flutter__app/shared/widgets/sidebar/sidebar_menu.dart';
import 'package:ztech_flutter__app/features/admin/data/services/csv_export_service.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  Future<void> _ejecutarExportacion(BuildContext context, String nombre, Future<String> Function() exportarFunction) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generando CSV de $nombre...'),
        backgroundColor: AppColors.secondary,
      ),
    );

    try {
      final String filePath = await exportarFunction();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Archivo descargado exitosamente'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'ABRIR',
              textColor: Colors.white,
              onPressed: () {
                OpenFilex.open(filePath);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final csvExportService = CsvExportService();

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
              description: 'Incluye notebooks registrados, estado actual, ubicación física y fecha de ingreso.',
              buttonText: 'Descargar CSV Bodega',
              onPressed: () => _ejecutarExportacion(
                context, 
                'Bodega', 
                csvExportService.exportarInventarioCsv,
              ),
            ),
            _ReportCard(
              icon: Icons.build_circle_outlined,
              title: 'Reporte Técnico',
              description: 'Incluye cambios de estado, diagnóstico técnico, acciones realizadas y fecha.',
              buttonText: 'Descargar CSV Técnico',
              onPressed: () => _ejecutarExportacion(
                context, 
                'Técnico', 
                csvExportService.exportarHistorialTecnicoCsv,
              ),
            ),
            _ReportCard(
              icon: Icons.point_of_sale_outlined,
              title: 'Reporte de Ventas',
              description: 'Incluye ventas registradas, cliente, equipo vendido, precio, forma de pago y fecha.',
              buttonText: 'Descargar CSV Ventas',
              onPressed: () => _ejecutarExportacion(
                context, 
                'Ventas', 
                csvExportService.exportarVentasCsv,
              ),
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
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
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
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
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