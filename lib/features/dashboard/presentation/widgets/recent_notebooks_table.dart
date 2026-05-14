import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/notebook_utils.dart';
import '../../../../shared/components/estado_badge.dart';
import '../../../bodega/data/mock_notebooks.dart';

class RecentNotebooksTable extends StatelessWidget {
  const RecentNotebooksTable({super.key});

  @override
  Widget build(BuildContext context) {
    final recientes = mockNotebooks.take(5).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.sectionSpacing),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDimensions.spacingSmall,
            runSpacing: AppDimensions.spacingSmall,
            children: [
              const Text(
                'Últimos notebooks registrados',
                style: AppTextStyles.sectionTitle,
              ),
              OutlinedButton(onPressed: () {}, child: const Text('Ver todos')),
            ],
          ),

          const SizedBox(height: AppDimensions.inputSpacing),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: AppTextStyles.cardTitle,
              dataTextStyle: AppTextStyles.body,
              dataRowMaxHeight: 60,
              dataRowMinHeight: 60,
              columns: const [
                DataColumn(label: Text('Código interno')),
                DataColumn(label: Text('Marca / Modelo')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Ubicación')),
                DataColumn(label: Text('Fecha ingreso')),
              ],
              rows: recientes.map((notebook) {
                final statusColor = NotebookUtils.getStatusColor(
                  notebook.estado,
                );

                String ubicacion =
                    '${notebook.seccion} ${notebook.estante}-${notebook.nivel}';

                if (ubicacion.trim() == '- - -') {
                  ubicacion = 'No asignada';
                }

                return _buildDataRow(
                  code: notebook.codigo,
                  model: '${notebook.marca} ${notebook.modelo}',
                  status: notebook.estado,
                  statusColor: statusColor,
                  location: ubicacion,
                  date: '16/11/2024',
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow({
    required String code,
    required String model,
    required String status,
    required Color statusColor,
    required String location,
    required String date,
  }) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            code,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        DataCell(Text(model)),
        DataCell(EstadoBadge(status: status, color: statusColor)),
        DataCell(Text(location)),
        DataCell(Text(date)),
      ],
    );
  }
}
