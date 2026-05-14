import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../bodega/data/mock_notebooks.dart';

class StockAlert extends StatelessWidget {
  final VoidCallback onShowMessage;

  const StockAlert({super.key, required this.onShowMessage});

  @override
  Widget build(BuildContext context) {
    final int disponibles = mockNotebooks
        .where((n) => n.estado == 'Disponible')
        .length;

    if (disponibles >= 5) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.sectionSpacing),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        decoration: BoxDecoration(
          color: AppColors.statusRepair.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.statusRepair.withOpacity(0.45)),
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
