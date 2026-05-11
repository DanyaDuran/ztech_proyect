import 'package:flutter/material.dart';
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

  void searchNotebook(String query) {
    final results = notebooks.where((notebook) {
      final text =
          '${notebook.codigo}'
                  '${notebook.marca}'
                  '${notebook.modelo}'
                  '${notebook.estado}'
              .toLowerCase();

      return text.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredNotebooks = results;
    });
  }

  Color getStatusColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return Colors.green;

      case 'en reparación':
        return Colors.amber;

      case 'vendido':
        return Colors.blue;

      case 'merma':
        return Colors.red;

      case 'pendiente de revisión':
        return Colors.deepPurple;

      default:
        return Colors.grey;
    }
  }

  int getCountByStatus(String status) {
    return notebooks.where((n) => n.estado == status).length;
  }

  void filterByStatus(String status) {
    setState(() {
      filteredNotebooks = notebooks.where((n) => n.estado == status).toList();
    });

    Navigator.pop(context);
  }

  void showFilters() {
    final statuses = [
      'Disponible',
      'En reparación',
      'Vendido',
      'Merma',
      'Pendiente de revisión',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrar por estado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2A3D),
                ),
              ),

              const SizedBox(height: 20),

              ...statuses.map((status) {
                return ListTile(
                  leading: Icon(
                    Icons.circle,
                    size: 14,
                    color: getStatusColor(status),
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

  Widget buildStatusCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: Colors.grey.shade300),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),

          const SizedBox(height: 4),

          Icon(Icons.remove, size: 14, color: color),

          const SizedBox(height: 4),

          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotebookCard(NotebookModel notebook) {
    final statusColor = getStatusColor(notebook.estado);

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: Container(
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

        //Marca y Modelo
        title: Text(
          '${notebook.marca} ${notebook.modelo}',

          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F2A3D),
          ),
        ),

        /// Ubicación
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Código: ${notebook.codigo}',

                style: const TextStyle(color: Color(0xFF6B7C8A)),
              ),

              const SizedBox(height: 4),

              Text(
                notebook.estado.toLowerCase() == 'vendido'
                    ? 'Vendido'
                    : 'Ubicación: '
                          '${notebook.seccion}- '
                          'E ${notebook.estante}- '
                          'N ${notebook.nivel}',

                style: const TextStyle(color: Color(0xFF6B7C8A)),
              ),
            ],
          ),
        ),

        /// Estado
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            notebook.estado,

            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SidebarMenu(currentRoute: '/bodega'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F2A3D),
        elevation: 0,
        title: const Text(
          'Inventario',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E4F6D),
        foregroundColor: Colors.white,

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

        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Título
            const Text(
              'Inventario',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F2A3D),
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Gestión de notebooks en bodega',
              style: TextStyle(color: Color(0xFF6B7C8A)),
            ),

            const SizedBox(height: 20),

            // Buscador + filtros
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: searchNotebook,

                    decoration: InputDecoration(
                      hintText: 'Buscar por código, marca, modelo o estado...',

                      hintStyle: const TextStyle(color: Color(0xFF9AA9B5)),

                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF1E4F6D),
                      ),

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),

                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),

                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),

                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),

                        borderSide: BorderSide(
                          color: Color(0xFF1E4F6D),
                          width: 2,
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
                      borderRadius: BorderRadius.circular(14),
                    ),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),

                  onPressed: showFilters,

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
                    width: 90,
                    child: buildStatusCard(
                      'Disp.',
                      getCountByStatus('Disponible'),
                      getStatusColor('Disponible'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: buildStatusCard(
                      'Repar.',
                      getCountByStatus('En reparación'),
                      getStatusColor('En reparación'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: buildStatusCard(
                      'Vend.',
                      getCountByStatus('Vendido'),
                      getStatusColor('Vendido'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: buildStatusCard(
                      'Merma',
                      getCountByStatus('Merma'),
                      getStatusColor('Merma'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: buildStatusCard(
                      'Rev.',
                      getCountByStatus('Pendiente de revisión'),
                      getStatusColor('Pendiente de revisión'),
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
                      itemBuilder: (context, index) =>
                          buildNotebookCard(filteredNotebooks[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
