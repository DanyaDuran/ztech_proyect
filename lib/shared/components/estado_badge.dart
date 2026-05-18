import 'package:flutter/material.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

class EstadoBadge extends StatelessWidget {
  final String status;
  final Color color;

  const EstadoBadge({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),

      child: Text(status, style: AppTextStyles.badge.copyWith(color: color)),
    );
  }
}
