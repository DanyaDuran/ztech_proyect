import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../../../bodega/data/mock_notebooks.dart';
import '../../../bodega/domain/notebook_model.dart';

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
    notebooks = mockNotebooks.where((n) => n.estado == 'Disponible').toList();
    filteredNotebooks = notebooks;
  }

  void searchNotebook(String query) {
    final results = notebooks.where((notebook) {
      final text =
          '${notebook.codigo}'
                  '${notebook.marca}'
                  '${notebook.modelo}'
              .toLowerCase();
      return text.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredNotebooks = results;
    });
  }

  void filterByStatus(String status) {
    setState(() {
      filteredNotebooks = notebooks.where((n) => n.estado == status).toList();
    });
    Navigator.pop(context);
  }

  void showFilters() {
    final statuses = ['Disponible', 'Vendido'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrar notebooks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2A3D),
                ),
              ),
              const SizedBox(height: 20),
              ...statuses.map((status) {
                return ListTile(
                  leading: const Icon(
                    Icons.laptop_mac,
                    color: Color(0xFF1E4F6D),
                  ),
                  title: Text(status),
                  onTap: () => filterByStatus(status),
                );
              }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.refresh, color: Color(0xFF1E4F6D)),
                title: const Text('Mostrar todos'),
                onTap: () {
                  setState(() {
                    filteredNotebooks = notebooks;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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

  Widget buildNotebookCard(NotebookModel notebook) {
    final isSelected = selectedNotebooks.contains(notebook);

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.laptop_mac,
                size: 28,
                color: Color(0xFF0F2A3D),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${notebook.marca} ${notebook.modelo}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2A3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Código: ${notebook.codigo}',
                    style: const TextStyle(color: Color(0xFF6B7C8A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${notebook.procesador} • ${notebook.ram}',
                    style: const TextStyle(color: Color(0xFF6B7C8A)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${notebook.seccion}- E${notebook.estante}- N${notebook.nivel}',
                  style: const TextStyle(
                    color: Color(0xFF6B7C8A),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: notebook.estado == 'Vendido'
                        ? Colors.red.withOpacity(0.12)
                        : Colors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    notebook.estado,
                    style: TextStyle(
                      color: notebook.estado == 'Vendido'
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 75,
                  height: 24,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.red.shade400
                          : const Color(0xFF1E4F6D),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: notebook.estado == 'Disponible'
                        ? () => toggleSelection(notebook)
                        : null,

                    child: Text(
                      isSelected ? 'Quitar' : 'Seleccionar',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SidebarMenu(currentRoute: '/ventas'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F2A3D),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ventas',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F2A3D),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Registro de salidas de notebooks',
              style: TextStyle(color: Color(0xFF6B7C8A), fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Solo se muestran notebooks disponibles para venta.',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: searchNotebook,
                    decoration: InputDecoration(
                      hintText: 'Buscar por código, marca o modelo...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF9AA9B5),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF9AA9B5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFF1E4F6D),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E4F6D),
                    side: const BorderSide(color: Color(0xFF1E4F6D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onPressed: showFilters,
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
                      return buildNotebookCard(filteredNotebooks[index]);
                    },
                  ),
            const SizedBox(height: 16),
            const Text(
              'Acciones rápidas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F2A3D),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: registrarSalida,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3C73E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Registrar salida',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Registrar la venta o salida de un notebook',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: Color(0xFF0F2A3D),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Historial de ventas',
                                style: TextStyle(
                                  color: Color(0xFF0F2A3D),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF0F2A3D),
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ver todas las salidas registradas',
                          style: TextStyle(
                            color: Color(0xFF6B7C8A),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
