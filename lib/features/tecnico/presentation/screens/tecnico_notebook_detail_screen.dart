import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../bodega/domain/notebook_model.dart';

import '../dialogs/tecnico_estado_dialog.dart';
import '../widgets/tecnico_botton_navigation.dart';

import '../../../bodega/data/mock_status_history.dart';
import '../../../bodega/domain/status_history_model.dart';

class TecnicoNotebookDetailScreen extends StatelessWidget {
  final NotebookModel notebook;

  const TecnicoNotebookDetailScreen({super.key, required this.notebook});
  List<StatusHistoryModel> getHistory() {
    return mockStatusHistory
        .where((h) => h.codigoNotebook == notebook.codigo)
        .toList();
  }

  bool isPendiente() {
    return notebook.estado.toLowerCase() == 'pendiente de revisión';
  }

  bool isEnReparacion() {
    return notebook.estado.toLowerCase() == 'en reparación';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Detalle técnico', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.white,
        elevation: AppDimensions.appBarElevation,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),

      bottomNavigationBar: const TecnicoBottomNavigation(currentIndex: 0),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: AppDimensions.sectionSpacing),

            _buildInfoTable(),

            const SizedBox(height: AppDimensions.sectionSpacing),
            _buildHistorial(),

            const SizedBox(height: AppDimensions.sectionSpacing),

            _buildBotonTecnico(context),
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

            _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;

    switch (notebook.estado.toLowerCase()) {
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
      child: Text(
        notebook.estado,
        style: AppTextStyles.badge.copyWith(color: color),
      ),
    );
  }

  Widget _buildInfoTable() {
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
              'Especificaciones',
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingSmall),

            _row('Procesador', notebook.procesador),
            _row('RAM', notebook.ram),
            _row('Almacenamiento', notebook.almacenamiento),
            _row('Estado', notebook.estado),

            _row(
              'Problema\nreportado',
              notebook.descripcionProblema.isEmpty
                  ? 'Sin problema reportado'
                  : notebook.descripcionProblema,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorial() {
    final history = getHistory();

    return Card(
      color: AppColors.white,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historial técnico',
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingSmall),

            if (history.isEmpty)
              const Text('Sin historial disponible')
            else
              ...history.map(
                (h) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 0.6),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${h.estadoAnterior} → ${h.estadoNuevo}',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Obs: ${h.observacion}'),
                      const SizedBox(height: 4),
                      Text(
                        '${h.usuarioResponsable} - ${h.fecha.day}/${h.fecha.month}/${h.fecha.year}',
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.6)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 135,
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
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

  Widget _buildBotonTecnico(BuildContext context) {
    if (!isPendiente() && !isEnReparacion()) {
      return const SizedBox();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => TecnicoEstadoDialog(notebook: notebook),
          );
        },
        child: Text(
          isPendiente() ? 'Iniciar revisión' : 'Actualizar estado',
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}
