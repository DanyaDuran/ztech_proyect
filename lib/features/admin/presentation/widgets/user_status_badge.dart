import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class UserStatusBadge extends StatelessWidget {
  final bool activo;

  const UserStatusBadge({super.key, required this.activo});

  @override
  Widget build(BuildContext context) {
    final color = activo
        ? AppColors.statusAvailable
        : AppColors.statusDiscarded;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Text(
          activo ? 'Activo' : 'Inactivo',
          style: AppTextStyles.badge.copyWith(color: color),
        ),
      ),
    );
  }
}
