import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../bodega/data/mock_notebooks.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    final int disponibles = mockNotebooks
        .where((n) => n.estado == 'Disponible')
        .length;

    final int enReparacion = mockNotebooks
        .where((n) => n.estado == 'En reparación')
        .length;

    final int vendidos = mockNotebooks
        .where((n) => n.estado == 'Vendido')
        .length;

    final int merma = mockNotebooks.where((n) => n.estado == 'Merma').length;

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
          children: [
            _StatCard(
              title: 'Disponibles',
              count: disponibles.toString(),
              icon: Icons.laptop_chromebook,
              iconColor: AppColors.statusAvailable,
              trendText: '12% vs mes anterior',
              trendIcon: Icons.arrow_outward,
              trendColor: AppColors.statusAvailable,
            ),
            _StatCard(
              title: 'En reparación',
              count: enReparacion.toString(),
              icon: Icons.build_outlined,
              iconColor: AppColors.statusRepair,
              trendText: '5% vs mes anterior',
              trendIcon: Icons.arrow_downward,
              trendColor: AppColors.statusRepair,
            ),
            _StatCard(
              title: 'Vendidos',
              count: vendidos.toString(),
              icon: Icons.shopping_cart_outlined,
              iconColor: AppColors.statusSold,
              trendText: '8% vs mes anterior',
              trendIcon: Icons.arrow_outward,
              trendColor: AppColors.statusAvailable,
            ),
            _StatCard(
              title: 'Merma',
              count: merma.toString(),
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.statusDiscarded,
              trendText: '0% vs mes anterior',
              trendIcon: Icons.arrow_outward,
              trendColor: AppColors.statusDiscarded,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconColor;
  final String trendText;
  final IconData trendIcon;
  final Color trendColor;

  const _StatCard({
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
              color: iconColor.withOpacity(0.12),
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
