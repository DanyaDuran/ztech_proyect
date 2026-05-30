import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class TecnicoBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const TecnicoBottomNavigation({super.key, required this.currentIndex});

  void navigateTo(BuildContext context, int index) {
    if (index == currentIndex) return;

    String route;

    switch (index) {
      case 0:
        route = '/tecnico';
        break;
      case 1:
        route = '/tecnico/reparacion';
        break;
      case 2:
        route = '/tecnico/disponible';
        break;
      case 3:
        route = '/tecnico/merma';
        break;
      case 4:
        route = '/tecnico/historial';
        break;
      default:
        route = '/tecnico';
    }

    Navigator.pushReplacementNamed(context, route);
  }

  Widget buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => navigateTo(context, index),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingMedium,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.primary,
                size: AppDimensions.iconMedium,
              ),
              const SizedBox(height: AppDimensions.spacingXSmall),
              Text(
                label,
                style: isSelected ? AppTextStyles.button : AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingSmall),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          buildButton(
            context: context,
            label: 'Pend.',
            icon: Icons.pending_actions,
            index: 0,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          buildButton(
            context: context,
            label: 'Repar.',
            icon: Icons.build,
            index: 1,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          buildButton(
            context: context,
            label: 'Disp.',
            icon: Icons.check_circle,
            index: 2,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          buildButton(
            context: context,
            label: 'Merma',
            icon: Icons.delete,
            index: 3,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          buildButton(
            context: context,
            label: 'Hist',
            icon: Icons.history,
            index: 4,
          ),
        ],
      ),
    );
  }
}
