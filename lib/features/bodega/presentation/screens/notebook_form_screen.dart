import 'package:flutter/material.dart';

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

  String estado = 'Disponible';

  InputDecoration buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(icon, color: const Color(0xFF1E4F6D)),

      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),

        borderSide: BorderSide(color: Color(0xFF1E4F6D), width: 2),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }

          return null;
        },

        decoration: buildInputDecoration(label, icon).copyWith(hintText: hint),
      ),
    );
  }

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

  Color getStatusColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'disponible':
        return Colors.green;

      case 'en reparación':
        return Colors.amber;

      case 'vendido':
        return Colors.blue;

      case 'merma':
        return Colors.red;

      case 'pendiente de revisión':
        return Colors.deepPurple;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F2A3D),
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
              buildTextField(
                controller: codigoController,
                label: 'Código',
                hint: 'Ej: NB-011',
                icon: Icons.qr_code,
              ),

              buildTextField(
                controller: marcaController,
                label: 'Marca',
                hint: 'Ej: Lenovo',
                icon: Icons.business,
              ),

              buildTextField(
                controller: lineaController,
                label: 'Línea',
                hint: 'Ej: Thinkpad',
                icon: Icons.category,
              ),

              buildTextField(
                controller: modeloController,
                label: 'Modelo',
                hint: 'Ej: T14',
                icon: Icons.laptop_mac,
              ),

              buildTextField(
                controller: procesadorController,
                label: 'Procesador',
                hint: 'Ej: Intel Core i7',
                icon: Icons.memory,
              ),

              buildTextField(
                controller: generacionController,
                label: 'Generación',
                hint: 'Ej: 12va Gen',
                icon: Icons.update,
              ),

              buildTextField(
                controller: ramController,
                label: 'RAM',
                hint: 'Ej: 16GB',
                icon: Icons.storage,
                keyboardType: TextInputType.number,
              ),

              buildTextField(
                controller: almacenamientoController,
                label: 'Almacenamiento',
                hint: 'Ej: 512GB SSD',
                icon: Icons.sd_storage,
              ),

              buildTextField(
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
                    color: Color(0xFF0F2A3D),
                    fontWeight: FontWeight.w500,
                  ),

                  iconEnabledColor: const Color(0xFF1E4F6D),

                  decoration: buildInputDecoration(
                    'Estado',
                    Icons.info_outline,
                  ),

                  items:
                      [
                        'Disponible',
                        'En reparación',
                        'Merma',
                        'Pendiente de revisión',
                      ].map((status) {
                        return DropdownMenuItem(
                          value: status,

                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 12,
                                color: getStatusColor(status),
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

              buildTextField(
                controller: seccionController,
                label: 'Sección',
                hint: 'Ej: A',
                icon: Icons.grid_view,
              ),

              buildTextField(
                controller: estanteController,
                label: 'Estante',
                hint: 'Ej: 2',
                icon: Icons.shelves,
                keyboardType: TextInputType.number,
              ),

              buildTextField(
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
                    backgroundColor: const Color(0xFF1E4F6D),

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
