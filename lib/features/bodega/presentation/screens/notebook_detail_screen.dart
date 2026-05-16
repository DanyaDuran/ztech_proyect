import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/notebook_model.dart';

class NotebookDetailScreen extends StatelessWidget {
  final NotebookModel notebook;

  const NotebookDetailScreen({super.key, required this.notebook});

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
                _DetailRow('Código interno', notebook.codigo),

                _DetailRow(
                  'Fecha ingreso',
                  _formatDateTime(notebook.fechaIngreso),
                ),

                _DetailRow('Marca', notebook.marca),

                _DetailRow('Línea', notebook.linea),

                _DetailRow('Modelo', notebook.modelo),

                _DetailRow('Procesador', notebook.procesador),

                _DetailRow('Generación', notebook.generacion),

                _DetailRow('RAM', notebook.ram),

                _DetailRow('Almacenamiento', notebook.almacenamiento),

                _DetailRow('Tarjeta gráfica', notebook.tarjetaGrafica),

                _DetailRow('Estado', notebook.estado),

                _DetailRow(
                  'Ubicación',
                  '${notebook.seccion} - '
                      'Estante ${notebook.estante} - '
                      'Nivel ${notebook.nivel}',
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            _buildInfoTable(
              title: 'Información de bodega',

              rows: [
                _DetailRow(
                  'Descripción del problema',
                  notebook.descripcionProblema,
                ),

                _DetailRow(
                  'Observaciones de bodega',
                  notebook.observacionesBodega,
                ),
              ],
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
              width: 120,
              height: 85,

              decoration: BoxDecoration(
                color: AppColors.inputBackground,

                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),

                border: Border.all(color: AppColors.border),
              ),

              child: const Icon(
                Icons.laptop_mac,
                size: 55,
                color: AppColors.primary,
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

            _buildStatusBadge(notebook.estado),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String estado) {
    Color color;

    switch (estado.toLowerCase()) {
      case 'disponible':
        color = AppColors.statusAvailable;
        break;

      case 'en reparación':
      case 'en reparacion':
        color = AppColors.statusRepair;
        break;

      case 'vendido':
        color = AppColors.statusSold;
        break;

      case 'merma':
        color = AppColors.statusDiscarded;
        break;

      default:
        color = AppColors.statusPending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),

      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(estado, style: AppTextStyles.badge.copyWith(color: color)),
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
            width: 135,

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

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');

    final month = dateTime.month.toString().padLeft(2, '0');

    final year = dateTime.year.toString();

    final hour = dateTime.hour.toString().padLeft(2, '0');

    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year - $hour:$minute';
  }
}

class _DetailRow {
  final String label;
  final String value;

  _DetailRow(this.label, this.value);
}
