import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconColor;
  final String trendText;
  final IconData trendIcon;
  final Color trendColor;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.trendText,
    required this.trendIcon,
    required this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingSmall),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: AppDimensions.iconLarge),
          ),

          const Spacer(),

          Text(title, style: AppTextStyles.cardTitle),

          const SizedBox(height: AppDimensions.spacingXSmall),

          Text(
            count,
            style: AppTextStyles.statusCount.copyWith(color: iconColor),
          ),

          const Spacer(),

          Row(
            children: [
              Icon(trendIcon, size: AppDimensions.iconSmall, color: trendColor),

              const SizedBox(width: AppDimensions.spacingXSmall),

              Expanded(
                child: Text(
                  trendText,
                  style: AppTextStyles.badge.copyWith(color: trendColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
