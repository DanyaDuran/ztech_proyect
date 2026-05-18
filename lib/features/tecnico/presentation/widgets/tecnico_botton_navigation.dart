import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../screens/tecnico_home_screen.dart';
import '../screens/tecnico_reparacion_screen.dart';
import '../screens/tecnico_disponible_screen.dart';
import '../screens/tecnico_merma_screen.dart';
import '../screens/tecnico_historial_screen.dart';

class TecnicoBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const TecnicoBottomNavigation({super.key, required this.currentIndex});

  void navigateTo(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget screen;

    switch (index) {
      case 0:
        screen = const TecnicoHomeScreen();
        break;
      case 1:
        screen = const TecnicoReparacionScreen();
        break;

      case 2:
        screen = const TecnicoDisponiblesScreen();
        break;

      case 3:
        screen = const TecnicoMermaScreen();
        break;

      case 4:
        screen = const TecnicoHistorialScreen();
        break;
      default:
        screen = const TecnicoHomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
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
          const SizedBox(width: AppDimensions.spacingSmall),
        ],
      ),
    );
  }
}
