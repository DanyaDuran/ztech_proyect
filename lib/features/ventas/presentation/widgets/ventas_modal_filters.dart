import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/notebook_utils.dart';

class ModalFiltrosVentas {
  static void show({
    required BuildContext context,
    required Function(String status) onFilterSelected,
    required VoidCallback onReset,
  }) {
    final statuses = ['Disponible', 'Vendido'];

    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Filtrar notebooks',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),

              const SizedBox(height: 20),

              ...statuses.map((status) {
                return ListTile(
                  leading: Icon(
                    Icons.circle,
                    size: 14,
                    color: NotebookUtils.getStatusColor(status),
                  ),

                  title: Text(status),

                  onTap: () {
                    onFilterSelected(status);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
