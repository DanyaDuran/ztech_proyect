import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';
import 'package:ztech_flutter__app/core/utils/notebook_utils.dart';
import 'package:ztech_flutter__app/shared/components/estado_badge.dart';
import 'package:ztech_flutter__app/features/bodega/data/repositories/notebook_repository.dart';
import 'package:ztech_flutter__app/features/bodega/domain/notebook_model.dart';

class RecentNotebooksTable extends StatelessWidget {
  const RecentNotebooksTable({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = NotebookRepository();

    return StreamBuilder<List<NotebookModel>>(
      stream: repository.getNotebooks(),
      builder: (context, snapshot) {
        final recientes = (snapshot.data ?? []).take(5).toList();

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
              const Text(
                'Últimos notebooks registrados',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppDimensions.inputSpacing),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator())
              else if (recientes.isEmpty)
                const Text('No hay notebooks registrados')
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: AppTextStyles.cardTitle,
                    dataTextStyle: AppTextStyles.body,
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

                      final ubicacion =
                          '${notebook.seccion} ${notebook.estante}-${notebook.nivel}';

                      return DataRow(
                        cells: [
                          DataCell(Text(notebook.codigo)),
                          DataCell(
                            Text('${notebook.marca} ${notebook.modelo}'),
                          ),
                          DataCell(
                            EstadoBadge(
                              status: notebook.estado,
                              color: statusColor,
                            ),
                          ),
                          DataCell(
                            Text(
                              ubicacion.trim().isEmpty
                                  ? 'No asignada'
                                  : ubicacion,
                            ),
                          ),
                          DataCell(
                            Text(
                              '${notebook.fechaIngreso.day}/${notebook.fechaIngreso.month}/${notebook.fechaIngreso.year}',
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
