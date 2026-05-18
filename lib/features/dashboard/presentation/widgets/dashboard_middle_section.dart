import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../bodega/data/mock_notebooks.dart';

class DashboardMiddleSection extends StatelessWidget {
  final VoidCallback onShowMessage;

  const DashboardMiddleSection({super.key, required this.onShowMessage});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildPieChartCard()),
          const SizedBox(width: AppDimensions.sectionSpacing),
          Expanded(child: _buildRecentActivityCard()),
        ],
      );
    }

    return Column(
      children: [
        _buildPieChartCard(),
        const SizedBox(height: AppDimensions.sectionSpacing),
        _buildRecentActivityCard(),
      ],
    );
  }

  Widget _buildPieChartCard() {
    final int total = mockNotebooks.length;

    final int disponibles = mockNotebooks
        .where((n) => n.estado == 'Disponible')
        .length;

    final int reparacion = mockNotebooks
        .where((n) => n.estado == 'En reparación')
        .length;

    final int vendidos = mockNotebooks
        .where((n) => n.estado == 'Vendido')
        .length;

    final int merma = mockNotebooks.where((n) => n.estado == 'Merma').length;

    String porcentaje(int value) {
      if (total == 0) {
        return '0';
      }

      return ((value / total) * 100).toStringAsFixed(0);
    }

    double totalGrafico = (disponibles + reparacion + vendidos + merma)
        .toDouble();

    if (totalGrafico == 0) {
      totalGrafico = 1;
    }

    final double stop1 = disponibles / totalGrafico;
    final double stop2 = stop1 + (reparacion / totalGrafico);
    final double stop3 = stop2 + (vendidos / totalGrafico);

    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notebooks por estado', style: AppTextStyles.sectionTitle),

          const SizedBox(height: AppDimensions.sectionSpacing),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    stops: [0.0, stop1, stop1, stop2, stop2, stop3, stop3, 1.0],
                    colors: const [
                      AppColors.statusAvailable,
                      AppColors.statusAvailable,
                      AppColors.statusRepair,
                      AppColors.statusRepair,
                      AppColors.statusSold,
                      AppColors.statusSold,
                      AppColors.statusDiscarded,
                      AppColors.statusDiscarded,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Total', style: AppTextStyles.subtitle),
                        Text(
                          '$total',
                          style: AppTextStyles.statusCount.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 32),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(
                    color: AppColors.statusAvailable,
                    title: 'Disponibles',
                    subtitle: '$disponibles (${porcentaje(disponibles)}%)',
                  ),
                  const SizedBox(height: AppDimensions.spacingMedium),
                  _LegendItem(
                    color: AppColors.statusRepair,
                    title: 'En reparación',
                    subtitle: '$reparacion (${porcentaje(reparacion)}%)',
                  ),
                  const SizedBox(height: AppDimensions.spacingMedium),
                  _LegendItem(
                    color: AppColors.statusSold,
                    title: 'Vendidos',
                    subtitle: '$vendidos (${porcentaje(vendidos)}%)',
                  ),
                  const SizedBox(height: AppDimensions.spacingMedium),
                  _LegendItem(
                    color: AppColors.statusDiscarded,
                    title: 'Merma',
                    subtitle: '$merma (${porcentaje(merma)}%)',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Historial de cambios',
                  style: AppTextStyles.sectionTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: onShowMessage,
                child: const Text('Ver todo', style: AppTextStyles.filterText),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.inputSpacing),

          const _ActivityItem(
            icon: Icons.laptop_chromebook,
            iconColor: AppColors.statusAvailable,
            title: 'Notebook ASUS X515 ingresado a bodega',
            subtitle: 'Por Juan.',
            time: 'Hoy\n10:30',
          ),

          const Divider(height: 24),

          const _ActivityItem(
            icon: Icons.build_outlined,
            iconColor: AppColors.statusRepair,
            title: 'Notebook Lenovo L14 en reparación',
            subtitle: 'Por Técnico 1',
            time: 'Hoy\n09:15',
          ),

          const Divider(height: 24),

          const _ActivityItem(
            icon: Icons.shopping_cart_outlined,
            iconColor: AppColors.statusSold,
            title: 'Venta realizada - HP 240 G8',
            subtitle: 'Por Giuliana R.',
            time: 'Ayer\n16:45',
          ),

          const Divider(height: 24),

          const _ActivityItem(
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.statusDiscarded,
            title: 'Notebook Dell Latitude dado de baja',
            subtitle: 'Por Aaron M.',
            time: 'Ayer\n11:20',
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final Widget child;

  const _DashboardCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.sectionSpacing),
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
      child: child,
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;

  const _LegendItem({
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

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
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
            color: iconColor.withOpacity(0.12),
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
