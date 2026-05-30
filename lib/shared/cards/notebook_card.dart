import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';
import 'package:ztech_flutter__app/core/utils/notebook_utils.dart';
import 'package:ztech_flutter__app/features/bodega/domain/notebook_model.dart';
import 'package:ztech_flutter__app/features/bodega/presentation/screens/notebook_detail_screen.dart';
import 'package:ztech_flutter__app/shared/components/estado_badge.dart';

class NotebookCard extends StatelessWidget {
  final NotebookModel notebook;

  const NotebookCard({super.key, required this.notebook});

  @override
  Widget build(BuildContext context) {
    final statusColor = NotebookUtils.getStatusColor(notebook.estado);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotebookDetailScreen(notebook: notebook),
          ),
        );
      },
      child: Card(
        color: AppColors.white,
        elevation: AppDimensions.cardElevation,
        margin: const EdgeInsets.only(bottom: AppDimensions.inputSpacing),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppDimensions.cardPadding),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: const Icon(
              Icons.laptop_mac,
              size: AppDimensions.iconLarge,
              color: AppColors.secondary,
            ),
          ),
          title: Text(
            '${notebook.marca} ${notebook.modelo}',
            style: AppTextStyles.cardTitle,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Código: ${notebook.codigo}', style: AppTextStyles.body),
                const SizedBox(height: AppDimensions.spacingXSmall),
                Text(
                  'Ubicación: '
                  '${notebook.seccion} - '
                  '${notebook.estante} - '
                  '${notebook.nivel}',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          trailing: EstadoBadge(status: notebook.estado, color: statusColor),
        ),
      ),
    );
  }
}
