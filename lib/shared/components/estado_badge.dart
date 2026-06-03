import 'package:flutter/material.dart';
import 'package:ztech_flutter__app/core/theme/theme.dart';

class EstadoBadge extends StatelessWidget {
  final String status;
  final Color color;

  const EstadoBadge({super.key, required this.status, required this.color});

  String getDisplayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente de revisión':
        return 'En revisión';

      case 'en reparación':
        return 'Reparación';

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: SizedBox(
        width: 90,
        child: Text(
          getDisplayStatus(status),
          textAlign: TextAlign.center,
          style: AppTextStyles.badge.copyWith(color: color),
        ),
      ),
    );
  }
}
