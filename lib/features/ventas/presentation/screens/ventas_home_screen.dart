import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/notebook_utils.dart';

import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/search/campo_busqueda.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';

import '../../../bodega/data/repositories/notebook_repository.dart';
import '../../../bodega/domain/notebook_model.dart';

import '../widgets/ventas_actions_section.dart';
import '../widgets/ventas_info_banner.dart';
import '../widgets/ventas_modal_filters.dart';
import '../widgets/ventas_notebook_card.dart';

import 'registrar_venta_screen.dart';

class VentasHomeScreen extends StatefulWidget {
  const VentasHomeScreen({super.key});

  @override
  State<VentasHomeScreen> createState() => _VentasHomeScreenState();
}

class _VentasHomeScreenState extends State<VentasHomeScreen> {
  final NotebookRepository repository = NotebookRepository();

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  final ValueNotifier<String?> selectedNotebookCodigo = ValueNotifier<String?>(
    null,
  );

  NotebookModel? selectedNotebook;
  String? activeFilter;

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    searchQuery.dispose();
    selectedNotebookCodigo.dispose();
    super.dispose();
  }

  void searchNotebook(String query) {
    searchQuery.value = query;
  }

  List<NotebookModel> getBaseList(List<NotebookModel> notebooks) {
    if (activeFilter != null) {
      return notebooks.where((n) {
        return NotebookUtils.normalizeText(n.estado) ==
            NotebookUtils.normalizeText(activeFilter!);
      }).toList();
    }

    return notebooks.where((n) {
      return NotebookUtils.normalizeText(n.estado) == 'disponible';
    }).toList();
  }

  void toggleSelection(NotebookModel notebook) {
    if (NotebookUtils.normalizeText(notebook.estado) != 'disponible') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo se pueden seleccionar notebooks disponibles'),
        ),
      );
      return;
    }

    if (selectedNotebookCodigo.value == notebook.codigo) {
      selectedNotebookCodigo.value = null;
      selectedNotebook = null;
    } else {
      selectedNotebookCodigo.value = notebook.codigo;
      selectedNotebook = notebook;
    }
  }

  Future<void> registrarSalida() async {
    if (selectedNotebook == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona un notebook')),
      );
      return;
    }

    final notebook = selectedNotebook!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrarVentaScreen(
          notebook: notebook,
          onConfirmarVenta: () async {
            notebook.estado = 'Vendido';

            await repository.updateNotebook(notebook);

            if (!mounted) return;

            setState(() {
              selectedNotebookCodigo.value = null;
              selectedNotebook = null;
              activeFilter = null;
            });
          },
        ),
      ),
    );
  }

  void applyStatusFilter(String status) {
    setState(() {
      activeFilter = status;
      selectedNotebookCodigo.value = null;
      selectedNotebook = null;
    });
  }

  void resetFilters() {
    setState(() {
      activeFilter = null;
      selectedNotebookCodigo.value = null;
      selectedNotebook = null;
    });
  }

  void _showFiltersModal() {
    ModalFiltrosVentas.show(
      context: context,
      onFilterSelected: applyStatusFilter,
      onReset: resetFilters,
    );
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
      body: StreamBuilder<List<NotebookModel>>(
        stream: repository.getNotebooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error al cargar notebooks para ventas',
                style: AppTextStyles.subtitle,
              ),
            );
          }

          final notebooks = snapshot.data ?? [];

          return Padding(
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

                _buildSearchAndFilters(),

                const SizedBox(height: 24),

                _buildListHeader(title),

                const SizedBox(height: 12),

                Expanded(child: _buildNotebookList(notebooks)),

                const SizedBox(height: 16),

                VentasActionsSection(onRegistrarSalida: registrarSalida),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 380;

        if (isSmallScreen) {
          return Column(
            children: [
              CampoBusqueda(
                controller: searchController,
                focusNode: searchFocusNode,
                hint: 'Buscar por código, marca o modelo...',
                onChanged: searchNotebook,
              ),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: _buildFilterButton()),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: CampoBusqueda(
                controller: searchController,
                focusNode: searchFocusNode,
                hint: 'Buscar por código, marca o modelo...',
                onChanged: searchNotebook,
              ),
            ),
            const SizedBox(width: 12),
            _buildFilterButton(),
          ],
        );
      },
    );
  }

  Widget _buildFilterButton() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onPressed: _showFiltersModal,
      icon: const Icon(Icons.filter_alt_outlined, size: 18),
      label: const Text('Filtros', style: TextStyle(fontSize: 14)),
    );
  }

  Widget _buildListHeader(String title) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedNotebookCodigo,
      builder: (context, selectedCodigo, _) {
        return Row(
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
            if (selectedCodigo != null)
              const Text(
                '1 seleccionado',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildNotebookList(List<NotebookModel> notebooks) {
    return ValueListenableBuilder<String>(
      valueListenable: searchQuery,
      builder: (context, query, _) {
        final baseList = getBaseList(notebooks);

        final filteredNotebooks = NotebookUtils.searchNotebooks(
          notebooks: baseList,
          query: query,
        );

        if (filteredNotebooks.isEmpty) {
          return Center(
            child: Text(
              activeFilter == 'Vendido'
                  ? 'No hay notebooks vendidos'
                  : 'No hay notebooks disponibles',
            ),
          );
        }

        return ValueListenableBuilder<String?>(
          valueListenable: selectedNotebookCodigo,
          builder: (context, selectedCodigo, _) {
            return ListView.builder(
              itemCount: filteredNotebooks.length,
              itemBuilder: (context, index) {
                final notebook = filteredNotebooks[index];

                return VentaNotebookCard(
                  notebook: notebook,
                  isSelected: selectedCodigo == notebook.codigo,
                  onToggleSelection: () {
                    toggleSelection(notebook);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
