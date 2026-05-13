import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/notebook_utils.dart';
import '../../features/bodega/domain/notebook_model.dart';
import 'estado_badge.dart';

class NotebookCard extends StatelessWidget {
  final NotebookModel notebook;

  const NotebookCard({super.key, required this.notebook});

  @override
  Widget build(BuildContext context) {
    final statusColor = NotebookUtils.getStatusColor(notebook.estado);

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        contentPadding: const EdgeInsets.all(14),

        leading: Container(
          width: 50,
          height: 50,

          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10),
          ),

          child: const Icon(
            Icons.laptop_mac,
            size: 28,
            color: AppColors.secondary,
          ),
        ),

        title: Text(
          '${notebook.marca} ${notebook.modelo}',

          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Código: ${notebook.codigo}',

                style: const TextStyle(color: AppColors.textGrey),
              ),

              const SizedBox(height: 4),

              Text(
                notebook.estado.toLowerCase() == 'vendido'
                    ? 'Vendido'
                    : 'Ubicación: '
                          '${notebook.seccion} - '
                          'E${notebook.estante} - '
                          'N${notebook.nivel}',

                style: const TextStyle(color: AppColors.textGrey),
              ),
            ],
          ),
        ),

        trailing: EstadoBadge(status: notebook.estado, color: statusColor),
      ),
    );
  }
}
