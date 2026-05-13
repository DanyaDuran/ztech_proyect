import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../features/bodega/domain/notebook_model.dart';

class NotebookUtils {
  static Color getStatusColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return AppColors.disponible;

      case 'en reparación':
        return AppColors.reparacion;

      case 'vendido':
        return AppColors.vendido;

      case 'merma':
        return AppColors.merma;

      case 'pendiente de revisión':
        return AppColors.pendiente;

      default:
        return Colors.grey;
    }
  }

  static List<NotebookModel> searchNotebooks({
    required List<NotebookModel> notebooks,
    required String query,
  }) {
    return notebooks.where((notebook) {
      final text =
          '${notebook.codigo}'
                  '${notebook.marca}'
                  '${notebook.modelo}'
                  '${notebook.estado}'
              .toLowerCase();

      return text.contains(query.toLowerCase());
    }).toList();
  }

  static int getCountByStatus({
    required List<NotebookModel> notebooks,
    required String status,
  }) {
    return notebooks.where((n) => n.estado == status).length;
  }

  static List<NotebookModel> filterByStatus({
    required List<NotebookModel> notebooks,
    required String status,
  }) {
    return notebooks.where((n) => n.estado == status).toList();
  }
}
