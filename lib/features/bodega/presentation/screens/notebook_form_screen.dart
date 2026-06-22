import 'package:flutter/material.dart';
import 'package:ztech_flutter__app/shared/styles/input_decorations.dart';

import 'package:ztech_flutter__app/core/theme/app_colors.dart';
import 'package:ztech_flutter__app/core/utils/utils.dart';
import 'package:ztech_flutter__app/shared/widgets/forms/widgets.dart';
import 'package:ztech_flutter__app/shared/widgets/buttons/primary_action_button.dart';
import 'package:ztech_flutter__app/features/bodega/data/notebook_options.dart';
import 'package:ztech_flutter__app/features/bodega/data/repositories/notebook_repository.dart';
import 'package:ztech_flutter__app/features/bodega/domain/notebook_model.dart';

class NotebookFormScreen extends StatefulWidget {
  final NotebookModel? notebook;

  const NotebookFormScreen({super.key, this.notebook});

  @override
  State<NotebookFormScreen> createState() => _NotebookFormScreenState();
}

class _NotebookFormScreenState extends State<NotebookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final NotebookRepository _notebookRepository = NotebookRepository();

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

  bool get esEdicion => widget.notebook != null;

  List<String> get seriesProcesadorFiltradas {
    if (familiaProcesador == 'Intel Core') {
      return ['i3', 'i5', 'i7', 'i9'];
    }

    if (familiaProcesador == 'AMD Ryzen') {
      return ['Ryzen 3', 'Ryzen 5', 'Ryzen 7', 'Ryzen 9'];
    }

    return [];
  }

  final List<String> estadosDisponibles = ['Pendiente de revisión'];

  @override
  void initState() {
    super.initState();

    if (esEdicion) {
      _cargarDatosNotebook();
    } else {
      _generarCodigoAutomatico();
    }
  }

  void _cargarDatosNotebook() {
    final notebook = widget.notebook!;

    codigoController.text = notebook.codigo;
    modeloController.text = notebook.modelo;
    descripcionProblemaController.text = notebook.descripcionProblema;
    observacionesBodegaController.text = notebook.observacionesBodega;

    marca = notebook.marca;
    linea = notebook.linea;
    generacion = notebook.generacion;
    ram = notebook.ram;
    almacenamiento = notebook.almacenamiento;
    tarjetaGrafica = notebook.tarjetaGrafica;
    seccion = notebook.seccion;
    estante = notebook.estante;
    nivel = notebook.nivel;
    estado = 'Pendiente de revisión';

    _cargarProcesador(notebook.procesador);
  }

  void _cargarProcesador(String procesador) {
    if (procesador.startsWith('Intel Core')) {
      familiaProcesador = 'Intel Core';
      serieProcesador = procesador.replaceFirst('Intel Core', '').trim();
    } else if (procesador.startsWith('AMD Ryzen')) {
      familiaProcesador = 'AMD Ryzen';
      final serie = procesador.replaceFirst('AMD', '').trim();
      serieProcesador = serie;
    }
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
      final notebooks = await _notebookRepository.getNotebooksOnce();
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
      if (esEdicion) {
        await _notebookRepository.updateNotebook(notebook);
      } else {
        await _notebookRepository.addNotebook(notebook);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            esEdicion
                ? 'Notebook actualizado correctamente'
                : 'Notebook registrado correctamente',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            esEdicion
                ? 'Error al actualizar el notebook'
                : 'Error al guardar el notebook',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _buildProcesador() {
    final familia = familiaProcesador?.trim() ?? '';
    final serie = serieProcesador?.trim() ?? '';

    if (familia.isEmpty) return serie;
    if (serie.isEmpty) return familia;

    if (familia == 'AMD Ryzen' && serie.startsWith('Ryzen')) {
      return serie.replaceFirst('Ryzen', 'AMD Ryzen').trim();
    }

    if (familia == 'Intel Core' && !serie.startsWith('Intel')) {
      return '$familia $serie'.trim();
    }

    return '$familia $serie'.trim();
  }

  NotebookModel _buildNotebookModel() {
    return NotebookModel(
      codigo: codigoController.text.trim(),
      marca: marca ?? '',
      linea: linea ?? '',
      modelo: modeloController.text.trim(),
      procesador: _buildProcesador(),
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
      fechaIngreso: widget.notebook?.fechaIngreso ?? DateTime.now(),
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
        title: Text(
          esEdicion ? 'Editar notebook' : 'Registrar notebook',
          style: const TextStyle(fontWeight: FontWeight.bold),
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

              TextFormField(
                controller: codigoController,
                readOnly: true,
                validator: AppValidators.codigoNotebook,
                decoration: customInputDecoration(
                  label: 'Código Interno',
                  icon: Icons.qr_code,
                ).copyWith(hintText: 'Ej: ZT-001'),
              ),

              const SizedBox(height: 16),

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
                onChanged: (val) {
                  setState(() {
                    familiaProcesador = val;
                    serieProcesador = null;
                  });
                },
              ),

              CustomDropdownField(
                label: 'Serie CPU',
                icon: Icons.memory_outlined,
                hint: familiaProcesador == null
                    ? 'Selecciona primero la familia'
                    : 'Selecciona la serie',
                value: serieProcesador,
                items: seriesProcesadorFiltradas,
                onChanged: (val) {
                  if (familiaProcesador == null) {
                    return;
                  }

                  setState(() {
                    serieProcesador = val;
                  });
                },
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
                    label: esEdicion ? 'Estado' : 'Estado inicial',
                    icon: Icons.info_outline,
                  ),
                  items: estadosDisponibles.map((status) {
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
                text: esEdicion ? 'Guardar cambios' : 'Guardar notebook',
                loadingText: esEdicion ? 'Actualizando...' : 'Guardando...',
                icon: esEdicion ? Icons.save_as : Icons.save,
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
