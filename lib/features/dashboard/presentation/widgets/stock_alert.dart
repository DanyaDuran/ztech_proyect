import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/helpers/notebook_status_helper.dart';
import 'package:ztech_flutter__app/core/theme/theme.dart';
import 'package:ztech_flutter__app/features/bodega/data/mock_notebooks.dart';

class StockAlert extends StatelessWidget {
  final VoidCallback onShowMessage;

  const StockAlert({super.key, required this.onShowMessage});

  @override
  Widget build(BuildContext context) {
    final int disponibles = NotebookStatusHelper.countByStatus(
      mockNotebooks,
      NotebookStatusHelper.disponible,
    );

    if (disponibles >= 5) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.sectionSpacing),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        decoration: BoxDecoration(
          color: AppColors.statusRepair.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: AppColors.statusRepair.withValues(alpha: 0.45),
          ),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppDimensions.inputSpacing,
          runSpacing: AppDimensions.inputSpacing,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.statusRepair,
              size: 32,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alerta de stock bajo',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.statusRepair,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXSmall),
                Text(
                  'Quedan $disponibles notebooks disponibles. '
                  'Se recomienda realizar una nueva compra.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            OutlinedButton(
              onPressed: onShowMessage,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.statusRepair,
                side: const BorderSide(color: AppColors.statusRepair),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
              ),
              child: const Text('Ver inventario'),
            ),
          ],
        ),
      ),
    );
  }
}
