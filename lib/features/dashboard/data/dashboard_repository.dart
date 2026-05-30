import 'package:flutter/material.dart';

import '../../../core/helpers/notebook_status_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../bodega/data/repositories/notebook_repository.dart';
import '../domain/models/dashboard_activity_item_model.dart';
import '../domain/models/dashboard_stat_item.dart';

class DashboardRepository {
  static final NotebookRepository _notebookRepository = NotebookRepository();

  static Future<List<DashboardStatItem>> getStats() async {
    final notebooks = await _notebookRepository.getNotebooksOnce();

    final disponibles = NotebookStatusHelper.countByStatus(
      notebooks,
      NotebookStatusHelper.disponible,
    );

    final reparacion = NotebookStatusHelper.countByStatus(
      notebooks,
      NotebookStatusHelper.reparacion,
    );

    final vendidos = NotebookStatusHelper.countByStatus(
      notebooks,
      NotebookStatusHelper.vendido,
    );

    final merma = NotebookStatusHelper.countByStatus(
      notebooks,
      NotebookStatusHelper.merma,
    );

    return [
      DashboardStatItem(
        title: 'Disponibles',
        count: disponibles,
        icon: NotebookStatusHelper.getStatusIcon(
          NotebookStatusHelper.disponible,
        ),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.disponible,
        ),
        trendText: 'Datos actualizados',
        trendIcon: Icons.sync,
        trendColor: AppColors.statusAvailable,
      ),
      DashboardStatItem(
        title: 'En reparación',
        count: reparacion,
        icon: NotebookStatusHelper.getStatusIcon(
          NotebookStatusHelper.reparacion,
        ),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.reparacion,
        ),
        trendText: 'Datos actualizados',
        trendIcon: Icons.sync,
        trendColor: AppColors.statusRepair,
      ),
      DashboardStatItem(
        title: 'Vendidos',
        count: vendidos,
        icon: NotebookStatusHelper.getStatusIcon(NotebookStatusHelper.vendido),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.vendido,
        ),
        trendText: 'Datos actualizados',
        trendIcon: Icons.sync,
        trendColor: AppColors.statusAvailable,
      ),
      DashboardStatItem(
        title: 'Merma',
        count: merma,
        icon: NotebookStatusHelper.getStatusIcon(NotebookStatusHelper.merma),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.merma,
        ),
        trendText: 'Datos actualizados',
        trendIcon: Icons.sync,
        trendColor: AppColors.statusDiscarded,
      ),
    ];
  }

  static List<DashboardActivityItemModel> getActivities() {
    return [];
  }
}
