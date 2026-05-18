import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/search/campo_busqueda.dart';

import '../../../bodega/data/mock_status_history.dart';
import '../../../bodega/domain/status_history_model.dart';
import '../widgets/tecnico_botton_navigation.dart';

class TecnicoHistorialScreen extends StatefulWidget {
  const TecnicoHistorialScreen({super.key});

  @override
  State<TecnicoHistorialScreen> createState() => _TecnicoHistorialScreenState();
}

class _TecnicoHistorialScreenState extends State<TecnicoHistorialScreen> {
  late List<StatusHistoryModel> history;
  late List<StatusHistoryModel> filteredHistory;

  @override
  void initState() {
    super.initState();
    history = mockStatusHistory.reversed.toList();
    filteredHistory = history;
  }

  void search(String query) {
    final text = query.toLowerCase().trim();

    setState(() {
      filteredHistory = history.where((h) {
        return h.codigoNotebook.toLowerCase().contains(text) ||
            h.estadoAnterior.toLowerCase().contains(text) ||
            h.estadoNuevo.toLowerCase().contains(text) ||
            h.diagnostico.toLowerCase().contains(text) ||
            h.accionesRealizadas.toLowerCase().contains(text) ||
            h.observacion.toLowerCase().contains(text);
      }).toList();
    });
  }

  Color getColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return AppColors.statusAvailable;
      case 'en reparacion':
      case 'en reparación':
        return AppColors.statusRepair;
      case 'pendiente de revisión':
        return AppColors.statusPending;
      case 'merma':
        return AppColors.statusDiscarded;
      case 'vendido':
        return AppColors.statusSold;
      default:
        return Colors.grey;
    }
  }

  String formatDate(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();

    final hour = fecha.hour.toString().padLeft(2, '0');
    final minute = fecha.minute.toString().padLeft(2, '0');

    return '$day/$month/$year - $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      drawer: const SidebarMenu(currentRoute: '/tecnico'),

      appBar: const CustomAppBar(title: 'Historial técnico'),

      bottomNavigationBar: const TecnicoBottomNavigation(currentIndex: 4),

      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text('Movimientos de estados', style: AppTextStyles.subtitle),

            const SizedBox(height: AppDimensions.sectionSpacing),

            CampoBusqueda(
              hint: 'Buscar por código, estado o detalle...',
              onChanged: search,
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            Expanded(
              child: filteredHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'Sin historial técnico',
                        style: AppTextStyles.subtitle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final h = filteredHistory[index];
                        final color = getColor(h.estadoNuevo);

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: AppDimensions.spacingMedium,
                          ),
                          padding: const EdgeInsets.all(
                            AppDimensions.cardPadding,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMedium,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.laptop_mac, color: color),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notebook ${h.codigoNotebook}',
                                          style: AppTextStyles.cardTitle,
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          '${h.estadoAnterior} → ${h.estadoNuevo}',
                                          style: AppTextStyles.subtitle
                                              .copyWith(
                                                color: color,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      h.estadoNuevo,
                                      style: AppTextStyles.subtitle.copyWith(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              if (h.diagnostico.trim().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    'Diagnóstico: ${h.diagnostico}',
                                    style: AppTextStyles.body,
                                  ),
                                ),

                              if (h.accionesRealizadas.trim().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    'Acciones: ${h.accionesRealizadas}',
                                    style: AppTextStyles.body,
                                  ),
                                ),

                              if (h.observacion.trim().isNotEmpty)
                                Text(
                                  'Observación: ${h.observacion}',
                                  style: AppTextStyles.body,
                                ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Por: ${h.usuarioResponsable}',
                                    style: AppTextStyles.subtitle,
                                  ),
                                  Text(
                                    formatDate(h.fecha),
                                    style: AppTextStyles.subtitle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
