import 'package:flutter/material.dart';
import 'package:ztech_flutter__app/shared/styles/input_decorations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/utils/code_generator.dart';
import '../../../../core/utils/notebook_utils.dart';
import '../../../../shared/widgets/forms/custom_dropdown_field.dart';
import '../../../../shared/widgets/forms/custom_text_field.dart';
import '../../../../shared/widgets/forms/form_section_title.dart';
import '../../data/notebook_options.dart';
import '../../data/repositories/notebook_repository.dart';
import '../../domain/notebook_model.dart';
import '../../../../shared/widgets/buttons/primary_action_button.dart';
import '../../../../shared/widgets/forms/custom_multiline_text_field.dart';

class NotebookFormScreen extends StatefulWidget {
  const NotebookFormScreen({super.key});

  @override
  State<NotebookFormScreen> createState() => _NotebookFormScreenState();
}

class _NotebookFormScreenState extends State<NotebookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notebookRepository = NotebookRepository();

  final codigoController = TextEditingController();
  final modeloController = TextEditingController();
  final descripcionProblemaController = TextEditingController();
  final observacionesBodegaController = TextEditingController();

  String? marca;
  String? linea;
  String? familiaProcesador;
  String? serieProcesador;
  String? generacion;
  String? ram;
  String? almacenamiento;
  String? tarjetaGrafica;
  String? seccion;
  String? estante;
  String? nivel;

  String estado = NotebookOptions.estadosInicialesBodega.first;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generarCodigoAutomatico();
  }

  @override
  void dispose() {
    codigoController.dispose();
    modeloController.dispose();
    descripcionProblemaController.dispose();
    observacionesBodegaController.dispose();
    super.dispose();
  }

  Future<void> _generarCodigoAutomatico() async {
    try {
      final notebooks = await _notebookRepository.getNotebooks();
      final currentCount = notebooks.length;
      final newCode = CodeGenerator.generateNotebookCode(currentCount);

      if (!mounted) return;

      setState(() {
        codigoController.text = newCode;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        codigoController.text = 'ZT-001';
      });
    }
  }

  Future<void> saveNotebook() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasSelectedTechnicalSpecs()) {
      _showMissingDropdownsMessage();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final notebook = _buildNotebookModel();

    try {
      if (!mounted) return;

      Navigator.pop(context, notebook);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notebook registrado correctamente')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar el notebook')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  NotebookModel _buildNotebookModel() {
    return NotebookModel(
      codigo: codigoController.text.trim(),
      marca: marca ?? '',
      linea: linea ?? '',
      modelo: modeloController.text.trim(),
      procesador: '${familiaProcesador ?? ''} ${serieProcesador ?? ''}'.trim(),
      generacion: generacion ?? '',
      ram: ram ?? '',
      almacenamiento: almacenamiento ?? '',
      tarjetaGrafica: tarjetaGrafica ?? '',
      estado: estado,
      seccion: seccion ?? '',
      estante: estante ?? '',
      nivel: nivel ?? '',
      descripcionProblema: descripcionProblemaController.text.trim(),
      observacionesBodega: observacionesBodegaController.text.trim(),
      fechaIngreso: DateTime.now(),
    );
  }

  bool _hasSelectedTechnicalSpecs() {
    return marca != null &&
        linea != null &&
        familiaProcesador != null &&
        serieProcesador != null &&
        generacion != null &&
        ram != null &&
        almacenamiento != null &&
        tarjetaGrafica != null &&
        seccion != null &&
        estante != null &&
        nivel != null;
  }

  void _showMissingDropdownsMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Completa todos los campos desplegables obligatorios'),
      ),
    );
  }

  void _updateEstado(String? value) {
    if (value == null) return;

    setState(() {
      estado = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
        elevation: 0,
        title: const Text(
          'Registrar notebook',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionTitle(
                title: 'Identificación del Equipo',
                icon: Icons.badge_outlined,
              ),

              CustomTextField(
                controller: codigoController,
                label: 'Código Interno',
                hint: 'Ej: ZT-001',
                icon: Icons.qr_code,
                validator: AppValidators.codigoNotebook,
              ),

              Row(
                children: [
                  Expanded(
                    child: CustomDropdownField(
                      label: 'Marca',
                      icon: Icons.business,
                      hint: 'Ej: Lenovo',
                      value: marca,
                      items: NotebookOptions.marcas,
                      onChanged: (val) => setState(() => marca = val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDropdownField(
                      label: 'Línea',
                      icon: Icons.category,
                      hint: 'Ej: Thinkpad',
                      value: linea,
                      items: NotebookOptions.lineas,
                      onChanged: (val) => setState(() => linea = val),
                    ),
                  ),
                ],
              ),

              CustomTextField(
                controller: modeloController,
                label: 'Modelo específico',
                hint: 'Ej: T123456',
                icon: Icons.laptop_mac,
                validator: AppValidators.modeloSerie,
              ),

              const Divider(height: 32),
              const FormSectionTitle(
                title: 'Especificaciones Técnicas',
                icon: Icons.memory,
              ),
              CustomDropdownField(
                label: 'Familia CPU',
                icon: Icons.memory,
                hint: 'Ej: Intel Core',
                value: familiaProcesador,
                items: NotebookOptions.familiasProcesador,
                onChanged: (val) => setState(() => familiaProcesador = val),
              ),

              CustomDropdownField(
                label: 'Serie CPU',
                icon: Icons.memory_outlined,
                hint: 'Ej: i7',
                value: serieProcesador,
                items: NotebookOptions.seriesProcesador,
                onChanged: (val) => setState(() => serieProcesador = val),
              ),

              CustomDropdownField(
                label: 'Generación',
                icon: Icons.update,
                hint: 'Ej: 12va Gen',
                value: generacion,
                items: NotebookOptions.generaciones,
                onChanged: (val) => setState(() => generacion = val),
              ),

              CustomDropdownField(
                label: 'Memoria RAM',
                icon: Icons.storage,
                hint: 'Ej: 16GB',
                value: ram,
                items: NotebookOptions.ram,
                onChanged: (val) => setState(() => ram = val),
              ),

              CustomDropdownField(
                label: 'Almacenamiento (Disco)',
                icon: Icons.sd_storage,
                hint: 'Ej: 512GB SSD',
                value: almacenamiento,
                items: NotebookOptions.almacenamiento,
                onChanged: (val) => setState(() => almacenamiento = val),
              ),

              CustomDropdownField(
                label: 'Tarjeta gráfica',
                icon: Icons.videogame_asset,
                hint: 'Ej: NVIDIA RTX 4060',
                value: tarjetaGrafica,
                items: NotebookOptions.tarjetasGraficas,
                onChanged: (val) => setState(() => tarjetaGrafica = val),
              ),

              const Divider(height: 32),
              const FormSectionTitle(
                title: 'Estado y Ubicación',
                icon: Icons.location_on_outlined,
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<String>(
                  initialValue: estado,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                  iconEnabledColor: AppColors.primary,
                  decoration: customInputDecoration(
                    label: 'Estado inicial',
                    icon: Icons.info_outline,
                  ),
                  items: NotebookOptions.estadosInicialesBodega.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: NotebookUtils.getStatusColor(status),
                          ),
                          const SizedBox(width: 10),
                          Text(status),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _updateEstado,
                ),
              ),

              CustomDropdownField(
                label: 'Sección',
                icon: Icons.grid_view,
                hint: 'Ej: A',
                value: seccion,
                items: NotebookOptions.secciones,
                onChanged: (val) => setState(() => seccion = val),
              ),

              Row(
                children: [
                  Expanded(
                    child: CustomDropdownField(
                      label: 'Estante',
                      icon: Icons.shelves,
                      hint: 'Ej: E1',
                      value: estante,
                      items: NotebookOptions.estantes,
                      onChanged: (val) => setState(() => estante = val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDropdownField(
                      label: 'Nivel',
                      icon: Icons.layers,
                      hint: 'Ej: N1',
                      value: nivel,
                      items: NotebookOptions.niveles,
                      onChanged: (val) => setState(() => nivel = val),
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),
              const FormSectionTitle(
                title: 'Detalles Adicionales',
                icon: Icons.notes,
              ),
              CustomMultilineTextField(
                controller: descripcionProblemaController,
                label: 'Descripción del problema',
                hint: 'Ej: No enciende al conectar cargador',
                icon: Icons.report_problem_outlined,
                validator: (val) =>
                    AppValidators.descripcionOpcional(val, 'La descripción'),
              ),

              const SizedBox(height: 16),

              CustomMultilineTextField(
                controller: observacionesBodegaController,
                label: 'Observaciones de bodega',
                hint: 'Ej: Equipo ingresa sin batería',
                icon: Icons.notes_outlined,
                validator: (val) =>
                    AppValidators.descripcionOpcional(val, 'La observación'),
              ),

              const SizedBox(height: 40),

              PrimaryActionButton(
                isLoading: _isLoading,
                text: 'Guardar notebook',
                loadingText: 'Guardando...',
                icon: Icons.save,
                onPressed: saveNotebook,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
