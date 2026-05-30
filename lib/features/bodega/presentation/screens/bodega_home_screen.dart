import 'package:flutter/material.dart';
import 'package:ztech_flutter__app/shared/cards/notebook_card.dart';
import 'package:ztech_flutter__app/core/theme/theme.dart';
import 'package:ztech_flutter__app/core/utils/notebook_utils.dart';
import 'package:ztech_flutter__app/shared/widgets/search/campo_busqueda.dart';
import 'package:ztech_flutter__app/shared/cards/estado_card.dart';
import 'package:ztech_flutter__app/shared/dialogs/modal_filtros_estado.dart';
import 'package:ztech_flutter__app/shared/widgets/sidebar/sidebar_menu.dart';
import 'package:ztech_flutter__app/shared/widgets/app_bar/custom_app_bar.dart';
import 'package:ztech_flutter__app/features/bodega/data/repositories/notebook_repository.dart';
import 'package:ztech_flutter__app/features/bodega/domain/notebook_model.dart';

import 'notebook_form_screen.dart';

class BodegaHomeScreen extends StatefulWidget {
  const BodegaHomeScreen({super.key});

  @override
  State<BodegaHomeScreen> createState() => _BodegaHomeScreenState();
}

class _BodegaHomeScreenState extends State<BodegaHomeScreen> {
  final NotebookRepository _notebookRepository = NotebookRepository();

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  String? selectedStatus;

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void searchNotebook(String query) {
    searchQuery.value = query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      drawer: const SidebarMenu(currentRoute: '/bodega'),

      appBar: const CustomAppBar(title: 'Inventario'),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add, size: AppDimensions.iconMedium),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotebookFormScreen()),
          );
        },
      ),

      body: StreamBuilder<List<NotebookModel>>(
        stream: _notebookRepository.getNotebooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar notebooks'));
          }

          final notebooks = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingXSmall),

                const Text(
                  'Gestión de notebooks en bodega',
                  style: AppTextStyles.subtitle,
                ),

                const SizedBox(height: AppDimensions.sectionSpacing),

                Row(
                  children: [
                    Expanded(
                      child: CampoBusqueda(
                        controller: searchController,
                        focusNode: searchFocusNode,
                        hint: 'Buscar por código, marca, modelo o estado...',
                        onChanged: searchNotebook,
                      ),
                    ),

                    const SizedBox(width: AppDimensions.spacingMedium),

                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMedium,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.buttonHorizontalPadding,
                          vertical: AppDimensions.buttonVerticalPadding,
                        ),
                      ),
                      onPressed: () {
                        ModalFiltrosEstado.show(
                          context: context,
                          onFilterSelected: (status) {
                            setState(() {
                              selectedStatus = status;
                            });
                          },
                          onReset: () {
                            setState(() {
                              selectedStatus = null;
                            });
                          },
                        );
                      },
                      icon: const Icon(Icons.filter_alt_outlined),
                      label: const Text('Filtros'),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.sectionSpacing),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppDimensions.statusCardWidth,
                        child: EstadoCard(
                          title: 'Disp.',
                          count: NotebookUtils.getCountByStatus(
                            notebooks: notebooks,
                            status: 'Disponible',
                          ),
                          color: AppColors.disponible,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingSmall),
                      SizedBox(
                        width: AppDimensions.statusCardWidth,
                        child: EstadoCard(
                          title: 'Repar',
                          count: NotebookUtils.getCountByStatus(
                            notebooks: notebooks,
                            status: 'En reparación',
                          ),
                          color: AppColors.reparacion,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingSmall),
                      SizedBox(
                        width: AppDimensions.statusCardWidth,
                        child: EstadoCard(
                          title: 'Vend.',
                          count: NotebookUtils.getCountByStatus(
                            notebooks: notebooks,
                            status: 'Vendido',
                          ),
                          color: AppColors.vendido,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingSmall),
                      SizedBox(
                        width: AppDimensions.statusCardWidth,
                        child: EstadoCard(
                          title: 'Merma',
                          count: NotebookUtils.getCountByStatus(
                            notebooks: notebooks,
                            status: 'Merma',
                          ),
                          color: AppColors.merma,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingSmall),
                      SizedBox(
                        width: AppDimensions.statusCardWidth,
                        child: EstadoCard(
                          title: 'Rev.',
                          count: NotebookUtils.getCountByStatus(
                            notebooks: notebooks,
                            status: 'Pendiente de revisión',
                          ),
                          color: AppColors.pendiente,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.sectionSpacing),

                Expanded(
                  child: ValueListenableBuilder<String>(
                    valueListenable: searchQuery,
                    builder: (context, query, _) {
                      List<NotebookModel> filteredNotebooks =
                          NotebookUtils.searchNotebooks(
                            notebooks: notebooks,
                            query: query,
                          );

                      if (selectedStatus != null) {
                        filteredNotebooks = NotebookUtils.filterByStatus(
                          notebooks: filteredNotebooks,
                          status: selectedStatus!,
                        );
                      }

                      return filteredNotebooks.isEmpty
                          ? const Center(
                              child: Text(
                                'No se encontraron notebooks',
                                style: AppTextStyles.subtitle,
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredNotebooks.length,
                              itemBuilder: (context, index) {
                                return NotebookCard(
                                  notebook: filteredNotebooks[index],
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
