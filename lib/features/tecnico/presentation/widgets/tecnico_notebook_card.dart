import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/estado_badge.dart';

import '../../../bodega/domain/notebook_model.dart';
import '../screens/tecnico_notebook_detail_screen.dart';

class TecnicoNotebookCard extends StatelessWidget {
  final NotebookModel notebook;

  const TecnicoNotebookCard({super.key, required this.notebook});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'disponible':
        return AppColors.disponible;

      case 'en reparación':
        return AppColors.reparacion;

      case 'merma':
        return AppColors.merma;

      default:
        return AppColors.pendiente;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TecnicoNotebookDetailScreen(notebook: notebook),
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
              Icons.build,
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
                  'Ubicación: ${notebook.seccion} - ${notebook.estante} - ${notebook.nivel}',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),

          trailing: EstadoBadge(
            status: notebook.estado,
            color: getStatusColor(notebook.estado),
          ),
        ),
      ),
    );
  }
}
