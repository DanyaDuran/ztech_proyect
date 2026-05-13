import 'package:flutter/material.dart';
import 'package:ztech_flutter__app/shared/widgets/input_decorations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/notebook_utils.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/notebook_model.dart';

class NotebookFormScreen extends StatefulWidget {
  const NotebookFormScreen({super.key});

  @override
  State<NotebookFormScreen> createState() => _NotebookFormScreenState();
}

class _NotebookFormScreenState extends State<NotebookFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final codigoController = TextEditingController();
  final marcaController = TextEditingController();
  final lineaController = TextEditingController();
  final modeloController = TextEditingController();
  final procesadorController = TextEditingController();
  final generacionController = TextEditingController();
  final ramController = TextEditingController();
  final almacenamientoController = TextEditingController();
  final tarjetaGraficaController = TextEditingController();
  final seccionController = TextEditingController();
  final estanteController = TextEditingController();
  final nivelController = TextEditingController();

  String estado = 'Pendiente de revisión';

  void saveNotebook() {
    if (_formKey.currentState!.validate()) {
      final notebook = NotebookModel(
        codigo: codigoController.text,
        marca: marcaController.text,
        linea: lineaController.text,
        modelo: modeloController.text,
        procesador: procesadorController.text,
        generacion: generacionController.text,
        ram: ramController.text,
        almacenamiento: almacenamientoController.text,
        tarjetaGrafica: tarjetaGraficaController.text,
        estado: estado,
        seccion: seccionController.text,
        estante: estanteController.text,
        nivel: nivelController.text,
      );

      Navigator.pop(context, notebook);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notebook registrado correctamente')),
      );
    }
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
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              CustomTextField(
                controller: codigoController,
                label: 'Código',
                hint: 'Ej: NB-011',
                icon: Icons.qr_code,
              ),

              CustomTextField(
                controller: marcaController,
                label: 'Marca',
                hint: 'Ej: Lenovo',
                icon: Icons.business,
              ),

              CustomTextField(
                controller: lineaController,
                label: 'Línea',
                hint: 'Ej: Thinkpad',
                icon: Icons.category,
              ),

              CustomTextField(
                controller: modeloController,
                label: 'Modelo',
                hint: 'Ej: T14',
                icon: Icons.laptop_mac,
              ),

              CustomTextField(
                controller: procesadorController,
                label: 'Procesador',
                hint: 'Ej: Intel Core i7',
                icon: Icons.memory,
              ),

              CustomTextField(
                controller: generacionController,
                label: 'Generación',
                hint: 'Ej: 12va Gen',
                icon: Icons.update,
              ),

              CustomTextField(
                controller: ramController,
                label: 'RAM',
                hint: 'Ej: 16GB',
                icon: Icons.storage,
                keyboardType: TextInputType.number,
              ),

              CustomTextField(
                controller: almacenamientoController,
                label: 'Almacenamiento',
                hint: 'Ej: 512GB SSD',
                icon: Icons.sd_storage,
              ),

              CustomTextField(
                controller: tarjetaGraficaController,
                label: 'Tarjeta gráfica',
                hint: 'Ej: RTX 4060',
                icon: Icons.videogame_asset,
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),

                child: DropdownButtonFormField<String>(
                  value: estado,

                  dropdownColor: Colors.white,

                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),

                  iconEnabledColor: AppColors.primary,

                  decoration: customInputDecoration(
                    label: 'Estado',
                    icon: Icons.info_outline,
                  ),

                  items: ['Merma', 'Pendiente de revisión'].map((status) {
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

                  onChanged: (value) {
                    setState(() {
                      estado = value!;
                    });
                  },
                ),
              ),

              CustomTextField(
                controller: seccionController,
                label: 'Sección',
                hint: 'Ej: A',
                icon: Icons.grid_view,
              ),

              CustomTextField(
                controller: estanteController,
                label: 'Estante',
                hint: 'Ej: 2',
                icon: Icons.shelves,
                keyboardType: TextInputType.number,
              ),

              CustomTextField(
                controller: nivelController,
                label: 'Nivel',
                hint: 'Ej: 1',
                icon: Icons.layers,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,

                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(vertical: 18),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: saveNotebook,

                  icon: const Icon(Icons.save),

                  label: const Text('Guardar notebook'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
