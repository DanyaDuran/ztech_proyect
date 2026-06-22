import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../bodega/data/repositories/status_history_repository.dart';
import '../../../bodega/domain/notebook_model.dart';
import '../../../bodega/domain/status_history_model.dart';
import '../../domain/venta_model.dart';

class VentasNotebookDetailScreen extends StatelessWidget {
  final NotebookModel? notebook;
  final VentaModel? venta;
  final VoidCallback? onRegistrarVenta;

  const VentasNotebookDetailScreen({
    super.key,
    this.notebook,
    this.venta,
    this.onRegistrarVenta,
  });

  NotebookModel get notebookFinal => venta?.notebook ?? notebook!;

  @override
  Widget build(BuildContext context) {
    final historyRepository = StatusHistoryRepository();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          venta == null ? 'Detalle del notebook' : 'Detalle de venta',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.white,
        elevation: AppDimensions.appBarElevation,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),

        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: AppDimensions.sectionSpacing),

            if (venta != null) ...[
              _buildVentaInfo(),
              const SizedBox(height: AppDimensions.sectionSpacing),
            ],

            _buildNotebookInfo(),
            const SizedBox(height: AppDimensions.sectionSpacing),
            _buildHistorialTecnico(historyRepository),

            if (onRegistrarVenta != null) ...[
              const SizedBox(height: AppDimensions.sectionSpacing),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                    ),
                  ),
                  onPressed: onRegistrarVenta,
                  child: const Text('Registrar Venta'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: AppColors.white,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          children: [
            const Icon(Icons.laptop_mac, size: 60, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              '${notebookFinal.marca} ${notebookFinal.modelo}',
              textAlign: TextAlign.center,
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: 4),
            Text(
              'Código: ${notebookFinal.codigo}',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.statusSold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                venta == null ? notebookFinal.estado : 'Vendido',
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.statusSold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVentaInfo() {
    final ventaFinal = venta!;

    return _buildCard(
      title: 'Datos de la venta',
      children: [
        _row('Cliente', ventaFinal.cliente),
        _row('Teléfono', ventaFinal.telefono),
        _row('Precio', '\$${ventaFinal.precio}'),
        _row('Forma de pago', ventaFinal.formaPago),
        _row('Fecha venta', _formatDateTime(ventaFinal.fechaVenta)),
        if (ventaFinal.notas.trim().isNotEmpty) _row('Notas', ventaFinal.notas),
      ],
    );
  }

  Widget _buildNotebookInfo() {
    return _buildCard(
      title: 'Datos del notebook',
      children: [
        _row('Marca', notebookFinal.marca),
        _row('Línea', notebookFinal.linea),
        _row('Modelo', notebookFinal.modelo),
        _row('Procesador', notebookFinal.procesador),
        _row('Generación', notebookFinal.generacion),
        _row('RAM', notebookFinal.ram),
        _row('Almacenamiento', notebookFinal.almacenamiento),
        _row('Tarjeta gráfica', notebookFinal.tarjetaGrafica),
        _row('Estado', notebookFinal.estado),
        _row(
          'Ubicación',
          '${notebookFinal.seccion} - Estante ${notebookFinal.estante} - Nivel ${notebookFinal.nivel}',
        ),
        _row(
          'Problema',
          notebookFinal.descripcionProblema.isEmpty
              ? 'Sin problema reportado'
              : notebookFinal.descripcionProblema,
        ),
        _row(
          'Obs. bodega',
          notebookFinal.observacionesBodega.isEmpty
              ? '-'
              : notebookFinal.observacionesBodega,
        ),
      ],
    );
  }

  Widget _buildHistorialTecnico(StatusHistoryRepository historyRepository) {
    return Card(
      color: AppColors.white,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: StreamBuilder<List<StatusHistoryModel>>(
          stream: historyRepository.getHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final history = (snapshot.data ?? [])
                .where((h) => h.codigoNotebook == notebookFinal.codigo)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Acciones realizadas por técnico',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: AppDimensions.spacingSmall),
                if (history.isEmpty)
                  const Text('Sin acciones técnicas registradas')
                else
                  ...history.map(
                    (h) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${h.estadoAnterior} → ${h.estadoNuevo}',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (h.diagnostico.trim().isNotEmpty)
                            Text('Diagnóstico: ${h.diagnostico}'),
                          if (h.accionesRealizadas.trim().isNotEmpty)
                            Text('Acciones: ${h.accionesRealizadas}'),
                          if (h.observacion.trim().isNotEmpty)
                            Text('Observación: ${h.observacion}'),
                          Text(
                            '${h.usuarioResponsable} - ${_formatDateTime(h.fecha)}',
                            style: AppTextStyles.subtitle,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      color: AppColors.white,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.cardTitle),
            const SizedBox(height: AppDimensions.spacingSmall),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              '$label:',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value.trim().isEmpty ? '-' : value,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year - $hour:$minute';
  }
}
