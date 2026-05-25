import 'package:flutter/material.dart';
import 'package:ztech_flutter__app/core/theme/theme.dart';

class EstadoBadge extends StatelessWidget {
  final String status;
  final Color color;

  const EstadoBadge({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),

      child: Text(status, style: AppTextStyles.badge.copyWith(color: color)),
    );
  }
}
