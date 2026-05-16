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
import 'ventas_notebook_detail_screen.dart';
import 'registrar_venta_screen.dart';

class VentasHomeScreen extends StatefulWidget {
  const VentasHomeScreen({super.key});

  @override
  State<VentasHomeScreen> createState() => _VentasHomeScreenState();
}

class _VentasHomeScreenState extends State<VentasHomeScreen> {
  late List<NotebookModel> notebooks;
  late List<NotebookModel> filteredNotebooks;

  List<NotebookModel> selectedNotebooks = [];

  String searchQuery = '';
  String? activeFilter;

  @override
  void initState() {
    super.initState();

    notebooks = mockNotebooks;
    applyFilters();
  }

  List<NotebookModel> getBaseList() {
    if (activeFilter != null) {
      return notebooks.where((n) => n.estado == activeFilter).toList();
    }

    return notebooks.where((n) => n.estado == 'Disponible').toList();
  }

  void applyFilters() {
    final baseList = getBaseList();

    filteredNotebooks = NotebookUtils.searchNotebooks(
      notebooks: baseList,
      query: searchQuery,
    );
  }

  void searchNotebook(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
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
        selectedNotebooks.clear();
        selectedNotebooks.add(notebook);
      }
    });
  }

  void registrarSalida() {
    if (selectedNotebooks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona un notebook')),
      );
      return;
    }

    final notebook = selectedNotebooks.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VentasNotebookDetailScreen(
          notebook: notebook,
          onRegistrarVenta: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RegistrarVentaScreen(
                  notebook: notebook,
                  onConfirmarVenta: () {
                    setState(() {
                      notebook.estado = 'Vendido';
                      selectedNotebooks.clear();
                      activeFilter = null;
                      applyFilters();
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void applyStatusFilter(String status) {
    setState(() {
      activeFilter = status;
      selectedNotebooks.clear();
      applyFilters();
    });
  }

  void resetFilters() {
    setState(() {
      activeFilter = null;
      selectedNotebooks.clear();
      applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = activeFilter == 'Vendido'
        ? 'Notebooks vendidos'
        : 'Notebooks disponibles';

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
                    foregroundColor: AppColors.primary,
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
                      onFilterSelected: applyStatusFilter,
                      onReset: resetFilters,
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),

                if (selectedNotebooks.isNotEmpty)
                  Text(
                    '${selectedNotebooks.length} seleccionado',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            filteredNotebooks.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        activeFilter == 'Vendido'
                            ? 'No hay notebooks vendidos'
                            : 'No hay notebooks disponibles',
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredNotebooks.length,
                    itemBuilder: (context, index) {
                      final notebook = filteredNotebooks[index];

                      return VentaNotebookCard(
                        notebook: notebook,
                        isSelected: selectedNotebooks.contains(notebook),
                        onToggleSelection: () {
                          toggleSelection(notebook);
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
