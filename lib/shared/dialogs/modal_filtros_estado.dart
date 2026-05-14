import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/notebook_utils.dart';

class ModalFiltrosEstado {
  static void show({
    required BuildContext context,
    required Function(String status) onFilterSelected,
    required VoidCallback onReset,
  }) {
    final statuses = [
      'Disponible',
      'En reparación',
      'Vendido',
      'Merma',
      'Pendiente de revisión',
    ];

    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),

      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.sectionSpacing),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Filtrar por estado',
                style: AppTextStyles.sectionTitle,
              ),

              const SizedBox(height: AppDimensions.sectionSpacing),

              ...statuses.map((status) {
                return ListTile(
                  leading: Icon(
                    Icons.circle,
                    size: AppDimensions.iconSmall,
                    color: NotebookUtils.getStatusColor(status),
                  ),

                  title: Text(status, style: AppTextStyles.body),

                  onTap: () {
                    onFilterSelected(status);
                    Navigator.pop(context);
                  },
                );
              }),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.refresh, color: AppColors.primary),

                title: const Text('Mostrar todos', style: AppTextStyles.body),

                onTap: () {
                  onReset();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
