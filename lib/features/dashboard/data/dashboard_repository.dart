import 'package:flutter/material.dart';

import '../../../core/helpers/notebook_status_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../bodega/data/mock_notebooks.dart';
import '../domain/models/dashboard_activity_item_model.dart';
import '../domain/models/dashboard_stat_item.dart';

class DashboardRepository {
  static List<DashboardStatItem> getStats() {
    final disponibles = NotebookStatusHelper.countByStatus(
      mockNotebooks,
      NotebookStatusHelper.disponible,
    );

    final reparacion = NotebookStatusHelper.countByStatus(
      mockNotebooks,
      NotebookStatusHelper.reparacion,
    );

    final vendidos = NotebookStatusHelper.countByStatus(
      mockNotebooks,
      NotebookStatusHelper.vendido,
    );

    final merma = NotebookStatusHelper.countByStatus(
      mockNotebooks,
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
        trendText: '12% vs mes anterior',
        trendIcon: Icons.arrow_outward,
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
        trendText: '5% vs mes anterior',
        trendIcon: Icons.arrow_downward,
        trendColor: AppColors.statusRepair,
      ),

      DashboardStatItem(
        title: 'Vendidos',
        count: vendidos,
        icon: NotebookStatusHelper.getStatusIcon(NotebookStatusHelper.vendido),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.vendido,
        ),
        trendText: '8% vs mes anterior',
        trendIcon: Icons.arrow_outward,
        trendColor: AppColors.statusAvailable,
      ),

      DashboardStatItem(
        title: 'Merma',
        count: merma,
        icon: NotebookStatusHelper.getStatusIcon(NotebookStatusHelper.merma),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.merma,
        ),
        trendText: '0% vs mes anterior',
        trendIcon: Icons.arrow_outward,
        trendColor: AppColors.statusDiscarded,
      ),
    ];
  }

  static List<DashboardActivityItemModel> getActivities() {
    return [
      DashboardActivityItemModel(
        icon: NotebookStatusHelper.getStatusIcon(
          NotebookStatusHelper.disponible,
        ),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.disponible,
        ),
        title: 'Notebook ASUS X515 ingresado a bodega',
        subtitle: 'Por Juan.',
        time: 'Hoy\n10:30',
      ),

      DashboardActivityItemModel(
        icon: NotebookStatusHelper.getStatusIcon(
          NotebookStatusHelper.reparacion,
        ),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.reparacion,
        ),
        title: 'Notebook Lenovo L14 en reparación',
        subtitle: 'Por Técnico 1',
        time: 'Hoy\n09:15',
      ),

      DashboardActivityItemModel(
        icon: NotebookStatusHelper.getStatusIcon(NotebookStatusHelper.vendido),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.vendido,
        ),
        title: 'Venta realizada - HP 240 G8',
        subtitle: 'Por Giuliana R.',
        time: 'Ayer\n16:45',
      ),

      DashboardActivityItemModel(
        icon: NotebookStatusHelper.getStatusIcon(NotebookStatusHelper.merma),
        iconColor: NotebookStatusHelper.getStatusColor(
          NotebookStatusHelper.merma,
        ),
        title: 'Notebook Dell Latitude dado de baja',
        subtitle: 'Por Aaron M.',
        time: 'Ayer\n11:20',
      ),
    ];
  }
}
