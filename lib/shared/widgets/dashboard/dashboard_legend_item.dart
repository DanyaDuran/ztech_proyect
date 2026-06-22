import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';

class DashboardLegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;

  const DashboardLegendItem({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: AppDimensions.spacingSmall),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            Text(subtitle, style: AppTextStyles.subtitle),
          ],
        ),
      ],
    );
  }
}
