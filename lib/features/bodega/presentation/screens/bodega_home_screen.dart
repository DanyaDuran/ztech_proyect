import 'package:flutter/material.dart';
import 'package:ztech_flutter__app/shared/cards/notebook_card.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/notebook_utils.dart';
import '../../../../shared/widgets/search/campo_busqueda.dart';
import '../../../../shared/cards/estado_card.dart';
import '../../../../shared/dialogs/modal_filtros_estado.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../../data/mock_notebooks.dart';
import '../../domain/notebook_model.dart';
import 'notebook_form_screen.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';

class BodegaHomeScreen extends StatefulWidget {
  const BodegaHomeScreen({super.key});

  @override
  State<BodegaHomeScreen> createState() => _BodegaHomeScreenState();
}

class _BodegaHomeScreenState extends State<BodegaHomeScreen> {
  late List<NotebookModel> notebooks;
  late List<NotebookModel> filteredNotebooks;

  @override
  void initState() {
    super.initState();

    notebooks = mockNotebooks;
    filteredNotebooks = notebooks;
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

        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotebookFormScreen()),
          );

          if (result != null && result is NotebookModel) {
            setState(() {
              notebooks.add(result);
              filteredNotebooks = notebooks;
            });
          }
        },
      ),
      body: Padding(
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
                    hint: 'Buscar por código, marca, modelo o estado...',
                    onChanged: (query) {
                      setState(() {
                        filteredNotebooks = NotebookUtils.searchNotebooks(
                          notebooks: notebooks,
                          query: query,
                        );
                      });
                    },
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
                          filteredNotebooks = NotebookUtils.filterByStatus(
                            notebooks: notebooks,
                            status: status,
                          );
                        });
                      },
                      onReset: () {
                        setState(() {
                          filteredNotebooks = notebooks;
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

            // Cantidades por estado
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
              child: filteredNotebooks.isEmpty
                  ? const Center(
                      child: Text(
                        'No se encontraron notebooks',
                        style: AppTextStyles.subtitle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredNotebooks.length,
                      itemBuilder: (context, index) {
                        return NotebookCard(notebook: filteredNotebooks[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
