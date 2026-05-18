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
    history = mockStatusHistory;
    filteredHistory = history;
  }

  void search(String query) {
    setState(() {
      filteredHistory = history.where((h) {
        return h.codigoNotebook.toLowerCase().contains(query.toLowerCase()) ||
            h.estadoNuevo.toLowerCase().contains(query.toLowerCase());
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

  Widget statusDot(String estado) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: getColor(estado),
        shape: BoxShape.circle,
      ),
    );
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
            const SizedBox(height: AppDimensions.spacingXSmall),

            const Text('Movimientos de estados', style: AppTextStyles.subtitle),

            const SizedBox(height: AppDimensions.sectionSpacing),

            Row(
              children: [
                Expanded(
                  child: CampoBusqueda(
                    hint: 'Buscar por estado...',
                    onChanged: search,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            Expanded(
              child: filteredHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'Sin historial',
                        style: AppTextStyles.subtitle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final h = filteredHistory[index];

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
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(children: [statusDot(h.estadoNuevo)]),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${h.estadoAnterior} → ${h.estadoNuevo}',
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      'Obs: ${h.observacion}',
                                      style: AppTextStyles.body,
                                    ),

                                    const SizedBox(height: 4),
                                    Text(
                                      'Diagnóstico: ${h.diagnostico}',
                                      style: AppTextStyles.body,
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      'Acciones: ${h.accionesRealizadas}',
                                      style: AppTextStyles.body,
                                    ),

                                    Text(
                                      'Por: ${h.usuarioResponsable}',
                                      style: AppTextStyles.subtitle,
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      '${h.fecha.day}/${h.fecha.month}/${h.fecha.year}',
                                      style: AppTextStyles.subtitle,
                                    ),
                                  ],
                                ),
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
