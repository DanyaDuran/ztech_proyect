import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/notebook_utils.dart';
import '../../../bodega/domain/notebook_model.dart';
import '../../../../shared/components/estado_badge.dart';

class VentaNotebookCard extends StatelessWidget {
  final NotebookModel notebook;
  final bool isSelected;
  final VoidCallback onToggleSelection;

  const VentaNotebookCard({
    super.key,
    required this.notebook,
    required this.isSelected,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = NotebookUtils.getStatusColor(notebook.estado);

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${notebook.marca} ${notebook.modelo}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Código: ${notebook.codigo}',
                    style: const TextStyle(color: AppColors.textGrey),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${notebook.procesador} • ${notebook.ram}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                EstadoBadge(status: notebook.estado, color: statusColor),

                const SizedBox(height: 8),

                SizedBox(
                  width: 107,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.red.shade400
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: notebook.estado == 'Disponible'
                        ? onToggleSelection
                        : null,
                    child: Text(
                      isSelected ? 'Quitar' : 'Seleccionar',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
