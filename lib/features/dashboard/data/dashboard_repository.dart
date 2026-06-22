import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/helpers/notebook_status_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/models/dashboard_activity_item_model.dart';
import '../domain/models/dashboard_stat_item.dart';

class DashboardRepository {
  static Future<List<DashboardStatItem>> getStats() async {
    final collection = FirebaseFirestore.instance.collection('notebooks');

    final results = await Future.wait([
      collection.where('estado', isEqualTo: NotebookStatusHelper.disponible).count().get(),
      collection.where('estado', isEqualTo: NotebookStatusHelper.reparacion).count().get(),
      collection.where('estado', isEqualTo: NotebookStatusHelper.vendido).count().get(),
      collection.where('estado', isEqualTo: NotebookStatusHelper.merma).count().get(),
    ]);

    final disponibles = results[0].count ?? 0;
    final reparacion = results[1].count ?? 0;
    final vendidos = results[2].count ?? 0;
    final merma = results[3].count ?? 0;

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
        icon: NotebookStatusHelper.getStatusIcon(
          NotebookStatusHelper.vendido,
        ),
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
        icon: NotebookStatusHelper.getStatusIcon(
          NotebookStatusHelper.merma,
        ),
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