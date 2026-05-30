import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../../features/bodega/domain/notebook_model.dart';

class NotebookUtils {
  static String normalizeText(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('Á', 'a')
        .replaceAll('É', 'e')
        .replaceAll('Í', 'i')
        .replaceAll('Ó', 'o')
        .replaceAll('Ú', 'u')
        .replaceAll('ñ', 'n')
        .replaceAll('Ñ', 'n');
  }

  static Color getStatusColor(String estado) {
    switch (normalizeText(estado)) {
      case 'disponible':
        return AppColors.disponible;

      case 'en reparacion':
        return AppColors.reparacion;

      case 'vendido':
        return AppColors.vendido;

      case 'merma':
        return AppColors.merma;

      case 'pendiente de revision':
        return AppColors.pendiente;

      default:
        return Colors.grey;
    }
  }

  static List<NotebookModel> searchNotebooks({
    required List<NotebookModel> notebooks,
    required String query,
  }) {
    final normalizedQuery = normalizeText(query);

    if (normalizedQuery.isEmpty) {
      return notebooks;
    }

    return notebooks.where((notebook) {
      final searchableText = normalizeText(
        [
          notebook.codigo,
          notebook.marca,
          notebook.linea,
          notebook.modelo,
          notebook.procesador,
          notebook.generacion,
          notebook.ram,
          notebook.almacenamiento,
          notebook.tarjetaGrafica,
          notebook.estado,
          notebook.seccion,
          notebook.estante,
          notebook.nivel,
          notebook.descripcionProblema,
          notebook.observacionesBodega,
        ].join(' '),
      );

      return searchableText.contains(normalizedQuery);
    }).toList();
  }

  static int getCountByStatus({
    required List<NotebookModel> notebooks,
    required String status,
  }) {
    final normalizedStatus = normalizeText(status);

    return notebooks.where((notebook) {
      return normalizeText(notebook.estado) == normalizedStatus;
    }).length;
  }

  static List<NotebookModel> filterByStatus({
    required List<NotebookModel> notebooks,
    required String status,
  }) {
    final normalizedStatus = normalizeText(status);

    return notebooks.where((notebook) {
      return normalizeText(notebook.estado) == normalizedStatus;
    }).toList();
  }
}
