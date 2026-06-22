import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';

import '../../data/repositories/ventas_repository.dart';
import '../../domain/venta_model.dart';
import 'ventas_notebook_detail_screen.dart';

class VentasHistoryScreen extends StatelessWidget {
  const VentasHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VentaRepository ventaRepository = VentaRepository();

    return Scaffold(
      backgroundColor: AppColors.background,

      drawer: const SidebarMenu(currentRoute: '/ventas'),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Historial de ventas',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      body: StreamBuilder<List<VentaModel>>(
        stream: ventaRepository.getVentas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error al cargar historial de ventas',
                style: AppTextStyles.subtitle,
              ),
            );
          }

          final ventas = snapshot.data ?? [];

          if (ventas.isEmpty) {
            return const Center(
              child: Text(
                'No hay ventas registradas',
                style: AppTextStyles.subtitle,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            itemCount: ventas.length,
            itemBuilder: (context, index) {
              final venta = ventas[index];

              return _VentaCard(
                venta: venta,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VentasNotebookDetailScreen(venta: venta),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _VentaCard extends StatelessWidget {
  final VentaModel venta;
  final VoidCallback onTap;

  const _VentaCard({required this.venta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: AppDimensions.cardElevation,
      margin: const EdgeInsets.only(bottom: AppDimensions.inputSpacing),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: const Icon(
                  Icons.laptop_mac,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${venta.notebook.marca} ${venta.notebook.modelo}',
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cliente: ${venta.cliente}',
                      style: AppTextStyles.body,
                    ),
                    Text(
                      'Código: ${venta.notebook.codigo}',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.secondary),
            ],
          ),
        ),
      ),
    );
  }
}
