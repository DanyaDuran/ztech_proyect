import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../bodega/data/mock_status_history.dart';
import '../../../bodega/domain/notebook_model.dart';
import '../../../bodega/domain/status_history_model.dart';

class TecnicoEstadoDialog extends StatefulWidget {
  final NotebookModel notebook;

  const TecnicoEstadoDialog({super.key, required this.notebook});

  @override
  State<TecnicoEstadoDialog> createState() => _TecnicoEstadoDialogState();
}

class _TecnicoEstadoDialogState extends State<TecnicoEstadoDialog> {
  final diagnosticoController = TextEditingController();

  final accionesController = TextEditingController();

  final observacionesController = TextEditingController();

  late String selectedStatus;

  bool get isPendiente =>
      widget.notebook.estado.toLowerCase() == 'pendiente de revisión';

  bool get isEnReparacion =>
      widget.notebook.estado.toLowerCase() == 'en reparación' ||
      widget.notebook.estado.toLowerCase() == 'en reparacion';

  @override
  void initState() {
    super.initState();

    selectedStatus = isPendiente ? 'En reparación' : 'Disponible';
  }

  @override
  void dispose() {
    diagnosticoController.dispose();
    accionesController.dispose();
    observacionesController.dispose();

    super.dispose();
  }

  Widget buildFixedTextArea({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return SizedBox(
      height: 95,
      child: TextField(
        controller: controller,
        maxLines: 3,
        minLines: 3,
        maxLength: 180,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        inputFormatters: [LengthLimitingTextInputFormatter(180)],
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  void guardarCambio() {
    if (isPendiente && diagnosticoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes ingresar un diagnóstico inicial')),
      );
      return;
    }

    if (isEnReparacion && accionesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes ingresar las acciones realizadas')),
      );
      return;
    }

    final estadoAnterior = widget.notebook.estado;

    widget.notebook.estado = selectedStatus;

    final history = StatusHistoryModel(
      codigoNotebook: widget.notebook.codigo,
      estadoAnterior: estadoAnterior,
      estadoNuevo: selectedStatus,
      usuarioResponsable: 'Técnico',
      fecha: DateTime.now(),
      diagnostico: diagnosticoController.text.trim(),
      accionesRealizadas: accionesController.text.trim(),
      observacion: isPendiente
          ? 'Diagnóstico inicial registrado'
          : observacionesController.text.trim().isEmpty
          ? 'Cambio de estado realizado por técnico'
          : observacionesController.text.trim(),
    );

    mockStatusHistory.add(history);

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isPendiente
              ? 'Notebook enviado a reparación'
              : 'Estado actualizado correctamente',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = isPendiente
        ? 'Iniciar revisión técnica'
        : 'Actualizar estado técnico';

    return Dialog(
      backgroundColor: AppColors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: SizedBox(
        width: 420,
        height: isPendiente ? 280 : 430,

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(title, style: AppTextStyles.sectionTitle),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (isPendiente) ...[
                        buildFixedTextArea(
                          controller: diagnosticoController,
                          label: 'Diagnóstico inicial',
                          hint: 'Ej: No enciende, posible falla de placa',
                        ),
                      ],

                      if (isEnReparacion) ...[
                        buildFixedTextArea(
                          controller: accionesController,
                          label: 'Acciones realizadas',
                          hint: 'Ej: Cambio de disco SSD y limpieza interna',
                        ),

                        const SizedBox(height: 16),

                        buildFixedTextArea(
                          controller: observacionesController,
                          label: 'Observaciones técnicas',
                          hint: 'Ej: Equipo queda funcionando correctamente',
                        ),

                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          initialValue: selectedStatus,

                          decoration: const InputDecoration(
                            labelText: 'Nuevo estado',
                            border: OutlineInputBorder(),
                          ),

                          items: const [
                            DropdownMenuItem(
                              value: 'Disponible',
                              child: Text('Disponible'),
                            ),

                            DropdownMenuItem(
                              value: 'En reparación',
                              child: Text('En reparación'),
                            ),

                            DropdownMenuItem(
                              value: 'Merma',
                              child: Text('Merma'),
                            ),
                          ],

                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),

                    child: const Text('Cancelar'),
                  ),

                  const SizedBox(width: 8),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),

                    onPressed: guardarCambio,

                    child: const Text('Guardar', style: AppTextStyles.button),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
