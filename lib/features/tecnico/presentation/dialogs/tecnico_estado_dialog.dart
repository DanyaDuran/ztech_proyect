import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/session/current_user.dart';

import '../../../bodega/domain/notebook_model.dart';
import '../../../bodega/domain/status_history_model.dart';

import '../../../bodega/data/repositories/notebook_repository.dart';
import '../../../bodega/data/repositories/status_history_repository.dart';

import '../../../admin/data/services/system_event_firestore_service.dart';
import '../../../admin/domain/system_event_model.dart';

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

  final NotebookRepository notebookRepository = NotebookRepository();
  final StatusHistoryRepository historyRepository = StatusHistoryRepository();

  late String selectedStatus;

  bool isSaving = false;

  late final bool esPendienteInicial;
  late final bool esReparacionInicial;

  bool get isPendiente => esPendienteInicial;
  bool get isEnReparacion => esReparacionInicial;
  bool get isCorreccion => !isPendiente && !isEnReparacion;

  @override
  void initState() {
    super.initState();

    final estadoInicial = widget.notebook.estado.toLowerCase().trim();

    esPendienteInicial = estadoInicial == 'pendiente de revisión';
    esReparacionInicial =
        estadoInicial == 'en reparación' || estadoInicial == 'en reparacion';

    selectedStatus = isPendiente ? 'En reparación' : widget.notebook.estado;
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

  Future<void> guardarCambio() async {
    if (isSaving) return;

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

    if (isCorreccion && observacionesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes ingresar una observación para corregir el estado',
          ),
        ),
      );
      return;
    }

    final estadoAnterior = widget.notebook.estado;

    if (estadoAnterior == selectedStatus) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un estado diferente')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      widget.notebook.estado = selectedStatus;

      await notebookRepository.updateNotebook(widget.notebook);

      await SystemEventFirestoreService().addEvent(
        SystemEventModel(
          usuario: CurrentUser.user?.correo ?? 'Usuario desconocido',
          tipoEvento: isCorreccion
              ? 'Corrección de estado'
              : 'Cambio de estado',
          modulo: 'Técnico',
          detalle:
              'Notebook ${widget.notebook.codigo} cambió de "$estadoAnterior" a "$selectedStatus"',
          fecha: DateTime.now(),
        ),
      );

      final history = StatusHistoryModel(
        codigoNotebook: widget.notebook.codigo,
        estadoAnterior: estadoAnterior,
        estadoNuevo: selectedStatus,
        usuarioResponsable: CurrentUser.user?.correo ?? 'Técnico',
        fecha: DateTime.now(),
        diagnostico: diagnosticoController.text.trim(),
        accionesRealizadas: accionesController.text.trim(),
        observacion: isPendiente
            ? 'Diagnóstico inicial registrado'
            : isCorreccion
            ? 'Corrección de estado: ${observacionesController.text.trim()}'
            : observacionesController.text.trim().isEmpty
            ? 'Cambio de estado realizado por técnico'
            : observacionesController.text.trim(),
      );

      await historyRepository.addHistory(history);

      if (!mounted) return;

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCorreccion
                ? 'Estado corregido correctamente'
                : estadoAnterior.toLowerCase().trim() == 'pendiente de revisión'
                ? 'Notebook enviado a reparación'
                : 'Estado actualizado correctamente',
          ),
        ),
      );
    } catch (e) {
      widget.notebook.estado = estadoAnterior;

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar cambio: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = isPendiente
        ? 'Iniciar revisión técnica'
        : isEnReparacion
        ? 'Actualizar estado técnico'
        : 'Corregir estado';

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
                          onChanged: isSaving
                              ? null
                              : (value) {
                                  setState(() {
                                    selectedStatus = value!;
                                  });
                                },
                        ),
                      ],

                      if (isCorreccion) ...[
                        buildFixedTextArea(
                          controller: observacionesController,
                          label: 'Motivo de corrección',
                          hint:
                              'Ej: Estado asignado por error, se corrige manualmente',
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
                              value: 'Pendiente de revisión',
                              child: Text('Pendiente de revisión'),
                            ),
                            DropdownMenuItem(
                              value: 'En reparación',
                              child: Text('En reparación'),
                            ),
                            DropdownMenuItem(
                              value: 'Disponible',
                              child: Text('Disponible'),
                            ),
                            DropdownMenuItem(
                              value: 'Merma',
                              child: Text('Merma'),
                            ),
                          ],
                          onChanged: isSaving
                              ? null
                              : (value) {
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
                    onPressed: isSaving
                        ? null
                        : () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),

                  const SizedBox(width: 8),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: isSaving ? null : guardarCambio,
                    child: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Guardar', style: AppTextStyles.button),
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
