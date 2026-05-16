import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/search/campo_busqueda.dart';
import '../../../../shared/cards/estado_card.dart';

import '../../../bodega/data/mock_notebooks.dart';
import '../../../bodega/domain/notebook_model.dart';

import '../widgets/tecnico_notebook_card.dart';
import '../widgets/tecnico_botton_navigation.dart';

import '../../../../core/utils/notebook_utils.dart';

class TecnicoReparacionScreen extends StatefulWidget {
  const TecnicoReparacionScreen({super.key});

  @override
  State<TecnicoReparacionScreen> createState() =>
      _TecnicoReparacionScreenState();
}

class _TecnicoReparacionScreenState extends State<TecnicoReparacionScreen> {
  late List<NotebookModel> notebooksReparacion;
  late List<NotebookModel> filteredNotebooks;

  @override
  void initState() {
    super.initState();

    notebooksReparacion = mockNotebooks
        .where((notebook) => notebook.estado.toLowerCase() == 'en reparación')
        .toList();

    filteredNotebooks = notebooksReparacion;
  }

  void searchNotebook(String query) {
    setState(() {
      filteredNotebooks = NotebookUtils.searchNotebooks(
        notebooks: notebooksReparacion,
        query: query,
      );
    });
  }

  int getCountByStatus(String status) {
    return mockNotebooks
        .where(
          (notebook) => notebook.estado.toLowerCase() == status.toLowerCase(),
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      drawer: const SidebarMenu(currentRoute: '/tecnico'),

      appBar: const CustomAppBar(title: 'En reparación'),

      bottomNavigationBar: const TecnicoBottomNavigation(currentIndex: 1),

      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.spacingXSmall),

            const Text(
              'Notebooks en reparación',
              style: AppTextStyles.subtitle,
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            Row(
              children: [
                Expanded(
                  child: CampoBusqueda(
                    hint: 'Buscar notebook por código o modelo...',
                    onChanged: searchNotebook,
                  ),
                ),

                const SizedBox(width: AppDimensions.spacingMedium),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            //Repetido del home de bodega
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: AppDimensions.statusCardWidth,
                    child: EstadoCard(
                      title: 'Pend.',
                      count: getCountByStatus('Pendiente de revisión'),
                      color: AppColors.pendiente,
                    ),
                  ),

                  const SizedBox(width: AppDimensions.spacingSmall),

                  SizedBox(
                    width: AppDimensions.statusCardWidth,
                    child: EstadoCard(
                      title: 'Repar.',
                      count: getCountByStatus('En reparación'),
                      color: AppColors.reparacion,
                    ),
                  ),

                  const SizedBox(width: AppDimensions.spacingSmall),

                  SizedBox(
                    width: AppDimensions.statusCardWidth,
                    child: EstadoCard(
                      title: 'Disp.',
                      count: getCountByStatus('Disponible'),
                      color: AppColors.disponible,
                    ),
                  ),

                  const SizedBox(width: AppDimensions.spacingSmall),

                  SizedBox(
                    width: AppDimensions.statusCardWidth,
                    child: EstadoCard(
                      title: 'Merma',
                      count: getCountByStatus('Merma'),
                      color: AppColors.merma,
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
                        'No hay notebooks en reparación',
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
