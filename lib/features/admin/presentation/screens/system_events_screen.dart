import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';
import 'package:ztech_flutter__app/shared/widgets/app_bar/custom_app_bar.dart';
import 'package:ztech_flutter__app/shared/widgets/sidebar/sidebar_menu.dart';
import 'package:ztech_flutter__app/features/admin/data/repositories/system_event_repository.dart';
import 'package:ztech_flutter__app/features/admin/domain/system_event_model.dart';

class SystemEventsScreen extends StatefulWidget {
  const SystemEventsScreen({super.key});

  @override
  State<SystemEventsScreen> createState() => _SystemEventsScreenState();
}

class _SystemEventsScreenState extends State<SystemEventsScreen> {
  final SystemEventRepository eventRepository = SystemEventRepository();

  String selectedModule = 'Todos';

  final List<String> modules = [
    'Todos',
    'Bodega',
    'Ventas',
    'Técnico',
    'Admin',
    'Auth',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SidebarMenu(currentRoute: '/admin/eventos'),
      appBar: const CustomAppBar(title: 'Eventos'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenPadding,
              AppDimensions.spacingMedium,
              AppDimensions.screenPadding,
              0,
            ),
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: modules.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.spacingSmall),
                itemBuilder: (context, index) {
                  final module = modules[index];
                  final isSelected = selectedModule == module;

                  return ChoiceChip(
                    label: Text(module),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.textOnDark
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) {
                      setState(() {
                        selectedModule = module;
                      });
                    },
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<SystemEventModel>>(
              stream: eventRepository.getEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar eventos'));
                }

                final allEvents = snapshot.data ?? [];

                final events = selectedModule == 'Todos'
                    ? allEvents
                    : allEvents
                          .where((event) => event.modulo == selectedModule)
                          .toList();

                if (events.isEmpty) {
                  return Center(
                    child: Text(
                      selectedModule == 'Todos'
                          ? 'No hay eventos registrados'
                          : 'No hay eventos para $selectedModule',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.screenPadding),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];

                    final fecha = DateFormat(
                      'dd/MM/yyyy - HH:mm',
                    ).format(event.fecha);

                    return Card(
                      color: AppColors.surface,
                      elevation: 3,
                      margin: const EdgeInsets.only(
                        bottom: AppDimensions.spacingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppDimensions.spacingMedium,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.tipoEvento,
                              style: AppTextStyles.subtitle.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: AppDimensions.spacingSmall),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                event.modulo,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: AppDimensions.spacingSmall),

                            Text(
                              'Usuario: ${event.usuario}',
                              style: AppTextStyles.body,
                            ),

                            Text(
                              'Detalle: ${event.detalle}',
                              style: AppTextStyles.body,
                            ),

                            Text('Fecha: $fecha', style: AppTextStyles.body),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
