import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onShowMessage;

  const DashboardHeader({super.key, required this.onShowMessage});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppDimensions.inputSpacing,
      runSpacing: AppDimensions.inputSpacing,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Resumen general del sistema', style: AppTextStyles.subtitle),
          ],
        ),

        Wrap(
          spacing: AppDimensions.spacingMedium,
          runSpacing: AppDimensions.spacingMedium,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: onShowMessage,
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Exportar inventario CSV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.textOnDark,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.buttonHorizontalPadding,
                  vertical: AppDimensions.buttonVerticalPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMedium,
                vertical: AppDimensions.spacingMedium,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppDimensions.spacingSmall),
                  Text('16 de noviembre de 2024', style: AppTextStyles.body),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
