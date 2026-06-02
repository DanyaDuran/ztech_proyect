import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/helpers/notebook_status_helper.dart';
import 'package:ztech_flutter__app/core/theme/theme.dart';
import 'package:ztech_flutter__app/shared/widgets/dashboard/widgets.dart';
import 'package:ztech_flutter__app/features/dashboard/data/dashboard_repository.dart';
import 'package:ztech_flutter__app/features/dashboard/domain/models/dashboard_stat_item.dart';
import 'package:ztech_flutter__app/features/bodega/data/repositories/status_history_repository.dart';
import 'package:ztech_flutter__app/features/bodega/domain/status_history_model.dart';

class DashboardMiddleSection extends StatelessWidget {
  final VoidCallback onShowMessage;

  const DashboardMiddleSection({super.key, required this.onShowMessage});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

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
    return FutureBuilder<List<DashboardStatItem>>(
      future: DashboardRepository.getStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const DashboardCard(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final stats = snapshot.data!;
        final total = stats.fold<int>(0, (sum, stat) => sum + stat.count);

        double totalGrafico = total.toDouble();
        if (totalGrafico == 0) {
          totalGrafico = 1;
        }

        final disponibles = stats[0].count;
        final reparacion = stats[1].count;
        final vendidos = stats[2].count;

        final stop1 = disponibles / totalGrafico;
        final stop2 = stop1 + (reparacion / totalGrafico);
        final stop3 = stop2 + (vendidos / totalGrafico);

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notebooks por estado',
                style: AppTextStyles.sectionTitle,
              ),

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
                        stops: [
                          0.0,
                          stop1,
                          stop1,
                          stop2,
                          stop2,
                          stop3,
                          stop3,
                          1.0,
                        ],
                        colors: [
                          stats[0].iconColor,
                          stats[0].iconColor,
                          stats[1].iconColor,
                          stats[1].iconColor,
                          stats[2].iconColor,
                          stats[2].iconColor,
                          stats[3].iconColor,
                          stats[3].iconColor,
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
                    children: stats.map((stat) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spacingMedium,
                        ),
                        child: DashboardLegendItem(
                          color: stat.iconColor,
                          title: stat.title,
                          subtitle:
                              '${stat.count} (${NotebookStatusHelper.percentage(stat.count, total)}%)',
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentActivityCard() {
    final historyRepository = StatusHistoryRepository();

    return DashboardCard(
      child: StreamBuilder<List<StatusHistoryModel>>(
        stream: historyRepository.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Text(
              'Error al cargar historial de cambios',
              style: AppTextStyles.subtitle,
            );
          }

          final history = (snapshot.data ?? []).toList()
            ..sort((a, b) => b.fecha.compareTo(a.fecha));

          final recentHistory = history.take(5).toList();

          return Column(
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
                ],
              ),

              const SizedBox(height: AppDimensions.inputSpacing),

              if (recentHistory.isEmpty)
                const Text(
                  'No hay actividad reciente',
                  style: AppTextStyles.body,
                )
              else
                ...recentHistory.asMap().entries.map((entry) {
                  final index = entry.key;
                  final historyItem = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notebook ${historyItem.codigoNotebook}',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${historyItem.estadoAnterior} → ${historyItem.estadoNuevo}',
                        style: AppTextStyles.body,
                      ),

                      const SizedBox(height: 4),

                      if (index != recentHistory.length - 1)
                        const Divider(height: 24),
                    ],
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
