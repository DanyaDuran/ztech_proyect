import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';

class DashboardActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const DashboardActivityItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: AppDimensions.iconMedium),
        ),

        const SizedBox(width: AppDimensions.inputSpacing),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
              ),

              const SizedBox(height: 2),

              Text(subtitle, style: AppTextStyles.subtitle),
            ],
          ),
        ),

        const SizedBox(width: AppDimensions.spacingSmall),

        Text(time, textAlign: TextAlign.right, style: AppTextStyles.subtitle),
      ],
    );
  }
}
