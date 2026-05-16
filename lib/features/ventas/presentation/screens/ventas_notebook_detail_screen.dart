import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../bodega/domain/notebook_model.dart';

class VentasNotebookDetailScreen extends StatelessWidget {
  final NotebookModel notebook;
  final VoidCallback onRegistrarVenta;

  const VentasNotebookDetailScreen({
    super.key,
    required this.notebook,
    required this.onRegistrarVenta,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Detalle Notebook', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.white,
        elevation: AppDimensions.appBarElevation,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),

        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: AppDimensions.sectionSpacing),

            _buildInfoTable(
              title: 'Especificaciones',
              rows: [
                _DetailRow('Procesador', notebook.procesador),
                _DetailRow('RAM', notebook.ram),
                _DetailRow('Almacenamiento', notebook.almacenamiento),
                _DetailRow('Gráfica', notebook.tarjetaGrafica),
                _DetailRow('Estado', notebook.estado),
                _DetailRow(
                  'Ubicación',
                  '${notebook.seccion} - Estante ${notebook.estante} - Nivel ${notebook.nivel}',
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                ),
                onPressed: onRegistrarVenta,
                child: const Text(
                  'Registrar Venta',
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: AppColors.white,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          children: [
            Container(
              width: 130,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.laptop_mac,
                color: AppColors.primary,
                size: 58,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingMedium),

            Text(
              '${notebook.marca} ${notebook.modelo}',
              textAlign: TextAlign.center,
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingXSmall),

            Text('Código: ${notebook.codigo}', style: AppTextStyles.subtitle),

            const SizedBox(height: AppDimensions.spacingSmall),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.statusAvailable.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                notebook.estado,
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.statusAvailable,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable({
    required String title,
    required List<_DetailRow> rows,
  }) {
    return Card(
      color: AppColors.white,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.cardPadding,
          vertical: AppDimensions.inputSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingSmall),

            ...rows.map((row) => _buildTableRow(row.label, row.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(width: AppDimensions.spacingSmall),

          Expanded(
            child: Text(
              value.trim().isEmpty ? '-' : value,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;

  _DetailRow(this.label, this.value);
}
