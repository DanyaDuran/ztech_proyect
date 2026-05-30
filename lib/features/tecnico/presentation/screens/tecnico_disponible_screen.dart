import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/notebook_utils.dart';

import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/search/campo_busqueda.dart';
import '../../../../shared/cards/estado_card.dart';

import '../../../bodega/data/repositories/notebook_repository.dart';
import '../../../bodega/domain/notebook_model.dart';

import '../widgets/tecnico_notebook_card.dart';
import '../widgets/tecnico_botton_navigation.dart';

class TecnicoDisponiblesScreen extends StatefulWidget {
  const TecnicoDisponiblesScreen({super.key});

  @override
  State<TecnicoDisponiblesScreen> createState() =>
      _TecnicoDisponiblesScreenState();
}

class _TecnicoDisponiblesScreenState extends State<TecnicoDisponiblesScreen> {
  final NotebookRepository repository = NotebookRepository();

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    searchQuery.dispose();
    super.dispose();
  }

  void searchNotebook(String query) {
    searchQuery.value = query;
  }

  int getCountByStatus(List<NotebookModel> notebooks, String status) {
    return notebooks
        .where(
          (notebook) =>
              NotebookUtils.normalizeText(notebook.estado) ==
              NotebookUtils.normalizeText(status),
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      drawer: const SidebarMenu(currentRoute: '/tecnico'),

      appBar: const CustomAppBar(title: 'Disponibles'),

      bottomNavigationBar: const TecnicoBottomNavigation(currentIndex: 2),

      body: StreamBuilder<List<NotebookModel>>(
        stream: repository.getNotebooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error al cargar notebooks',
                style: AppTextStyles.subtitle,
              ),
            );
          }

          final notebooks = snapshot.data ?? [];

          final notebooksDisponibles = notebooks.where((notebook) {
            return NotebookUtils.normalizeText(notebook.estado) == 'disponible';
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingXSmall),

                const Text(
                  'Notebooks disponibles',
                  style: AppTextStyles.subtitle,
                ),

                const SizedBox(height: AppDimensions.sectionSpacing),

                Row(
                  children: [
                    Expanded(
                      child: CampoBusqueda(
                        controller: searchController,
                        focusNode: searchFocusNode,
                        hint: 'Buscar notebook por código o modelo...',
                        onChanged: searchNotebook,
                      ),
                    ),

                    const SizedBox(width: AppDimensions.spacingMedium),
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
                          title: 'Pend.',
                          count: getCountByStatus(
                            notebooks,
                            'Pendiente de revisión',
                          ),
                          color: AppColors.pendiente,
                        ),
                      ),

                      const SizedBox(width: AppDimensions.spacingSmall),

                      SizedBox(
                        width: AppDimensions.statusCardWidth,
                        child: EstadoCard(
                          title: 'Repar.',
                          count: getCountByStatus(notebooks, 'En reparación'),
                          color: AppColors.reparacion,
                        ),
                      ),

                      const SizedBox(width: AppDimensions.spacingSmall),

                      SizedBox(
                        width: AppDimensions.statusCardWidth,
                        child: EstadoCard(
                          title: 'Disp.',
                          count: getCountByStatus(notebooks, 'Disponible'),
                          color: AppColors.disponible,
                        ),
                      ),

                      const SizedBox(width: AppDimensions.spacingSmall),

                      SizedBox(
                        width: AppDimensions.statusCardWidth,
                        child: EstadoCard(
                          title: 'Merma',
                          count: getCountByStatus(notebooks, 'Merma'),
                          color: AppColors.merma,
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
                      final filteredNotebooks = NotebookUtils.searchNotebooks(
                        notebooks: notebooksDisponibles,
                        query: query,
                      );

                      return filteredNotebooks.isEmpty
                          ? const Center(
                              child: Text(
                                'No hay notebooks disponibles',
                                style: AppTextStyles.subtitle,
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredNotebooks.length,
                              itemBuilder: (context, index) {
                                return TecnicoNotebookCard(
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
