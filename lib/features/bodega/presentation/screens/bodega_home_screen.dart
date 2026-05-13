import 'package:flutter/material.dart';
import 'package:ztech_flutter__app/shared/widgets/notebook_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/notebook_utils.dart';
import '../../../../shared/widgets/campo_busqueda.dart';
import '../../../../shared/widgets/estado_card.dart';
import '../../../../shared/widgets/modal_filtros_estado.dart';
import '../../../../shared/widgets/sidebar_menu.dart';
import '../../data/mock_notebooks.dart';
import '../../domain/notebook_model.dart';
import 'notebook_form_screen.dart';

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
      backgroundColor: Colors.white,
      drawer: const SidebarMenu(currentRoute: '/bodega'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
        elevation: 0,
        title: const Text(
          'Inventario',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inventario',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Gestión de notebooks en bodega',
              style: TextStyle(color: AppColors.textGrey),
            ),

            const SizedBox(height: 20),

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

                const SizedBox(width: 12),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,

                    side: const BorderSide(color: AppColors.primary),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
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

            const SizedBox(height: 20),

            // Cantidades por estado
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: EstadoCard(
                      title: 'Disp.',
                      count: NotebookUtils.getCountByStatus(
                        notebooks: notebooks,
                        status: 'Disponible',
                      ),
                      color: AppColors.disponible,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: EstadoCard(
                      title: 'Repar',
                      count: NotebookUtils.getCountByStatus(
                        notebooks: notebooks,
                        status: 'En reparación',
                      ),
                      color: AppColors.reparacion,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: EstadoCard(
                      title: 'Vend.',
                      count: NotebookUtils.getCountByStatus(
                        notebooks: notebooks,
                        status: 'Vendido',
                      ),
                      color: AppColors.vendido,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: EstadoCard(
                      title: 'Merma',
                      count: NotebookUtils.getCountByStatus(
                        notebooks: notebooks,
                        status: 'Merma',
                      ),
                      color: AppColors.merma,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
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

            const SizedBox(height: 20),
            Expanded(
              child: filteredNotebooks.isEmpty
                  ? const Center(child: Text('No se encontraron notebooks'))
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
