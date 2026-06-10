import 'package:flutter/material.dart';
import 'package:ztech_flutter__app/core/theme/app_dimensions.dart';
import 'package:ztech_flutter__app/shared/widgets/dashboard/dashboard_stat_card.dart';
import 'package:ztech_flutter__app/features/dashboard/data/dashboard_repository.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DashboardRepository.getStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error al cargar las estadísticas'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay datos disponibles'),
          );
        }

        final stats = snapshot.data!;

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
      },
    );
  }
}