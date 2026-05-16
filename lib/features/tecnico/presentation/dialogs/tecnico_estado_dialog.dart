import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../bodega/domain/notebook_model.dart';
import '../../../bodega/domain/status_history_model.dart';
import '../../../bodega/data/mock_status_history.dart';

class TecnicoEstadoDialog extends StatefulWidget {
  final NotebookModel notebook;

  const TecnicoEstadoDialog({super.key, required this.notebook});

  @override
  State<TecnicoEstadoDialog> createState() => _TecnicoEstadoDialogState();
}

class _TecnicoEstadoDialogState extends State<TecnicoEstadoDialog> {
  final TextEditingController diagnosticoController = TextEditingController();

  final TextEditingController observacionesController = TextEditingController();

  late String selectedStatus;

  @override
  void initState() {
    super.initState();

    selectedStatus = widget.notebook.estado.toLowerCase() == 'en reparación'
        ? 'Disponible'
        : 'En reparación';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,

      title: const Text('Revisión técnica', style: AppTextStyles.sectionTitle),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: diagnosticoController,
              decoration: const InputDecoration(
                labelText: 'Diagnóstico técnico',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: observacionesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Obervaciones/Acciones',
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: widget.notebook.estado.toLowerCase() == 'en reparación'
                  ? const [
                      DropdownMenuItem(
                        value: 'Disponible',
                        child: Text('Disponible'),
                      ),
                      DropdownMenuItem(value: 'Merma', child: Text('Merma')),
                    ]
                  : const [
                      DropdownMenuItem(
                        value: 'Disponible',
                        child: Text('Disponible'),
                      ),
                      DropdownMenuItem(
                        value: 'En reparación',
                        child: Text('En reparación'),
                      ),
                      DropdownMenuItem(value: 'Merma', child: Text('Merma')),
                    ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Nuevo estado'),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            final estadoAnterior = widget.notebook.estado;

            widget.notebook.estado = selectedStatus;

            // crear historial
            final history = StatusHistoryModel(
              codigoNotebook: widget.notebook.codigo,
              estadoAnterior: estadoAnterior,
              estadoNuevo: selectedStatus,
              usuarioResponsable: 'Técnico',
              fecha: DateTime.now(),

              diagnostico: diagnosticoController.text,
              accionesRealizadas: observacionesController.text,
              observacion: 'Cambio de estado realizado por técnico',
            );
            mockStatusHistory.add(history);

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Estado actualizado correctamente')),
            );
          },
          child: const Text('Guardar', style: AppTextStyles.button),
        ),
      ],
    );
  }
}
