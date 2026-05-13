import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../../../bodega/data/mock_notebooks.dart';
import '../../../bodega/domain/notebook_model.dart';
import '../../../../shared/cards/notebook_card.dart';
import '../../../../core/theme/app_colors.dart';

class VentasHistoryScreen extends StatelessWidget {
  const VentasHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotebookModel> vendidos = mockNotebooks
        .where((n) => n.estado == 'Vendido')
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SidebarMenu(currentRoute: '/ventas'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Historial de ventas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: vendidos.isEmpty
            ? const Center(child: Text('No hay ventas registradas'))
            : ListView.builder(
                itemCount: vendidos.length,
                itemBuilder: (context, index) {
                  return NotebookCard(notebook: vendidos[index]);
                },
              ),
      ),
    );
  }
}
