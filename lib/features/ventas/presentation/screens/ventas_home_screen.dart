import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../../../bodega/data/mock_notebooks.dart';
import '../../../bodega/domain/notebook_model.dart';
import '../../../../shared/widgets/search/campo_busqueda.dart';
import '../../../../core/utils/notebook_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/ventas_actions_section.dart';
import '../widgets/ventas_modal_filters.dart';
import '../widgets/ventas_notebook_card.dart';
import '../widgets/ventas_info_banner.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../core/theme/app_text_styles.dart';

class VentasHomeScreen extends StatefulWidget {
  const VentasHomeScreen({super.key});

  @override
  State<VentasHomeScreen> createState() => _VentasHomeScreenState();
}

class _VentasHomeScreenState extends State<VentasHomeScreen> {
  late List<NotebookModel> notebooks;
  late List<NotebookModel> filteredNotebooks;

  List<NotebookModel> selectedNotebooks = [];

  @override
  void initState() {
    super.initState();

    notebooks = mockNotebooks;

    filteredNotebooks = notebooks
        .where((n) => n.estado == 'Disponible')
        .toList();
  }

  void searchNotebook(String query) {
    setState(() {
      filteredNotebooks = NotebookUtils.searchNotebooks(
        notebooks: notebooks,
        query: query,
      );
    });
  }

  void toggleSelection(NotebookModel notebook) {
    if (notebook.estado != 'Disponible') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo se pueden seleccionar notebooks disponibles'),
        ),
      );
      return;
    }

    setState(() {
      if (selectedNotebooks.contains(notebook)) {
        selectedNotebooks.remove(notebook);
      } else {
        selectedNotebooks.add(notebook);
      }
    });
  }

  void registrarSalida() {
    if (selectedNotebooks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona al menos un notebook'),
        ),
      );
      return;
    }

    final cantidadBorrados = selectedNotebooks.length;

    setState(() {
      for (var notebook in selectedNotebooks) {
        notebook.estado = 'Vendido';
      }
      filteredNotebooks = notebooks
          .where((n) => n.estado == 'Disponible')
          .toList();
      selectedNotebooks.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$cantidadBorrados notebook(s) registrados como vendidos',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SidebarMenu(currentRoute: '/ventas'),
      appBar: const CustomAppBar(title: 'Ventas'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registro de salidas de notebooks',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: 16),
            const VentasInfoBanner(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CampoBusqueda(
                    hint: 'Buscar por código, marca o modelo...',
                    onChanged: searchNotebook,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E4F6D),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    ModalFiltrosVentas.show(
                      context: context,

                      onFilterSelected: (status) {
                        if (status != 'Disponible' && status != 'Vendido') {
                          return;
                        }

                        setState(() {
                          filteredNotebooks = notebooks
                              .where((n) => n.estado == status)
                              .toList();
                        });
                      },

                      onReset: () {
                        setState(() {
                          filteredNotebooks = notebooks
                              .where(
                                (n) =>
                                    n.estado == 'Disponible' ||
                                    n.estado == 'Vendido',
                              )
                              .toList();
                        });
                      },
                    );
                  },
                  icon: const Icon(Icons.filter_alt_outlined, size: 18),
                  label: const Text('Filtros', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notebooks disponibles',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2A3D),
                  ),
                ),
                if (selectedNotebooks.isNotEmpty)
                  Text(
                    '${selectedNotebooks.length} seleccionados',
                    style: const TextStyle(
                      color: Color(0xFF1E4F6D),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            filteredNotebooks.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text('No hay notebooks disponibles')),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredNotebooks.length,
                    itemBuilder: (context, index) {
                      return VentaNotebookCard(
                        notebook: filteredNotebooks[index],
                        isSelected: selectedNotebooks.contains(
                          filteredNotebooks[index],
                        ),
                        onToggleSelection: () {
                          toggleSelection(filteredNotebooks[index]);
                        },
                      );
                    },
                  ),
            const SizedBox(height: 16),
            VentasActionsSection(onRegistrarSalida: registrarSalida),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
