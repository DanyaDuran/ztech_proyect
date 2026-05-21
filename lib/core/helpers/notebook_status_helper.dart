import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NotebookStatusHelper {
  static const String disponible = 'Disponible';
  static const String reparacion = 'En reparación';
  static const String vendido = 'Vendido';
  static const String merma = 'Merma';

  static const List<String> allStatuses = [
    disponible,
    reparacion,
    vendido,
    merma,
  ];

  static Color getStatusColor(String status) {
    switch (status) {
      case disponible:
        return AppColors.statusAvailable;

      case reparacion:
        return AppColors.statusRepair;

      case vendido:
        return AppColors.statusSold;

      case merma:
        return AppColors.statusDiscarded;

      default:
        return Colors.grey;
    }
  }

  static IconData getStatusIcon(String status) {
    switch (status) {
      case disponible:
        return Icons.laptop_chromebook;

      case reparacion:
        return Icons.build_outlined;

      case vendido:
        return Icons.shopping_cart_outlined;

      case merma:
        return Icons.warning_amber_rounded;

      default:
        return Icons.help_outline;
    }
  }

  static int countByStatus(List<dynamic> notebooks, String status) {
    return notebooks.where((n) => n.estado == status).length;
  }

  static String percentage(int value, int total) {
    if (total == 0) {
      return '0';
    }

    return ((value / total) * 100).toStringAsFixed(0);
  }
}
