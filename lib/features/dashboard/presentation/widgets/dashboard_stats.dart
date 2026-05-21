import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../shared/widgets/dashboard/dashboard_stat_card.dart';
import '../../data/dashboard_repository.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = DashboardRepository.getStats();

    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppDimensions.inputSpacing,
          mainAxisSpacing: AppDimensions.inputSpacing,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: constraints.maxWidth < 600 ? 0.95 : 1.1,
          children: stats.map((stat) {
            return DashboardStatCard(
              title: stat.title,
              count: stat.count.toString(),
              icon: stat.icon,
              iconColor: stat.iconColor,
              trendText: stat.trendText,
              trendIcon: stat.trendIcon,
              trendColor: stat.trendColor,
            );
          }).toList(),
        );
      },
    );
  }
}
