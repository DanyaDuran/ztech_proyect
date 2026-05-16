import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../../data/mock_ventas.dart';
import '../../domain/venta_model.dart';

class VentasHistoryScreen extends StatelessWidget {
  const VentasHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<VentaModel> ventas = mockVentas.reversed.toList();

    return Scaffold(
      backgroundColor: AppColors.background,

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

        title: const Text(
          'Historial de ventas',
          style: AppTextStyles.appBarTitle,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),

        child: ventas.isEmpty
            ? const Center(
                child: Text(
                  'No hay ventas registradas',
                  style: AppTextStyles.subtitle,
                ),
              )
            : ListView.builder(
                itemCount: ventas.length,

                itemBuilder: (context, index) {
                  final venta = ventas[index];

                  return _VentaCard(venta: venta);
                },
              ),
      ),
    );
  }
}

class _VentaCard extends StatelessWidget {
  final VentaModel venta;

  const _VentaCard({required this.venta});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: AppDimensions.cardElevation,
      margin: const EdgeInsets.only(bottom: AppDimensions.inputSpacing),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),

      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
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
                        'Código: ${venta.notebook.codigo}',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.statusSold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    'Vendido',
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.statusSold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _buildRow('Cliente', venta.cliente),

            _buildRow('Teléfono', venta.telefono),

            _buildRow('Precio', '\$${venta.precio}'),

            _buildRow('Forma de pago', venta.formaPago),

            _buildRow(
              'Fecha',
              '${venta.fechaVenta.day.toString().padLeft(2, '0')}/'
                  '${venta.fechaVenta.month.toString().padLeft(2, '0')}/'
                  '${venta.fechaVenta.year} - '
                  '${venta.fechaVenta.hour.toString().padLeft(2, '0')}:'
                  '${venta.fechaVenta.minute.toString().padLeft(2, '0')}',
            ),

            if (venta.notas.trim().isNotEmpty) _buildRow('Notas', venta.notas),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 110,

            child: Text(
              '$label:',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          Expanded(child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}
