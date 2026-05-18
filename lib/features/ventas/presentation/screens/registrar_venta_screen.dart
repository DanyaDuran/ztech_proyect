import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../bodega/domain/notebook_model.dart';
import '../../data/mock_ventas.dart';
import '../../domain/venta_model.dart';

class RegistrarVentaScreen extends StatefulWidget {
  final NotebookModel notebook;
  final VoidCallback onConfirmarVenta;

  const RegistrarVentaScreen({
    super.key,
    required this.notebook,
    required this.onConfirmarVenta,
  });

  @override
  State<RegistrarVentaScreen> createState() => _RegistrarVentaScreenState();
}

class _RegistrarVentaScreenState extends State<RegistrarVentaScreen> {
  final _formKey = GlobalKey<FormState>();

  final clienteController = TextEditingController();
  final telefonoController = TextEditingController();
  final precioController = TextEditingController();
  final notasController = TextEditingController();

  String formaPago = 'Transferencia';

  @override
  void dispose() {
    clienteController.dispose();
    telefonoController.dispose();
    precioController.dispose();
    notasController.dispose();
    super.dispose();
  }

  void confirmarVenta() {
    if (_formKey.currentState!.validate()) {
      final venta = VentaModel(
        notebook: widget.notebook,
        cliente: clienteController.text.trim(),
        telefono: telefonoController.text.trim(),
        precio: precioController.text.trim(),
        formaPago: formaPago,
        notas: notasController.text.trim(),
        fechaVenta: DateTime.now(),
      );

      mockVentas.add(venta);
      widget.onConfirmarVenta();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venta registrada correctamente')),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Registrar Venta', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.white,
        elevation: AppDimensions.appBarElevation,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),

      body: Form(
        key: _formKey,

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildSectionTitle('Información del cliente'),

              const SizedBox(height: AppDimensions.spacingSmall),

              _buildTextField(
                controller: clienteController,
                label: 'Cliente',
                hint: 'Ej: Juan Pérez',
                icon: Icons.person_outline,
              ),

              _buildTextField(
                controller: telefonoController,
                label: 'Teléfono',
                hint: 'Ej: +56 9 1234 5678',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: AppDimensions.sectionSpacing),

              _buildSectionTitle('Información de venta'),

              const SizedBox(height: AppDimensions.spacingSmall),

              _buildReadOnlyField(
                label: 'Notebook',
                value:
                    '${widget.notebook.marca} ${widget.notebook.modelo} (${widget.notebook.codigo})',
                icon: Icons.laptop_mac,
              ),

              _buildTextField(
                controller: precioController,
                label: 'Precio de venta',
                hint: 'Ej: 650000',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<String>(
                  value: formaPago,
                  dropdownColor: AppColors.white,
                  decoration: _inputDecoration(
                    label: 'Forma de pago',
                    icon: Icons.payment_outlined,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Transferencia',
                      child: Text('Transferencia'),
                    ),
                    DropdownMenuItem(
                      value: 'Efectivo',
                      child: Text('Efectivo'),
                    ),
                    DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      formaPago = value!;
                    });
                  },
                ),
              ),

              TextFormField(
                controller: notasController,
                maxLines: 3,
                decoration:
                    _inputDecoration(
                      label: 'Notas opcionales',
                      icon: Icons.notes_outlined,
                    ).copyWith(
                      hintText: 'Añadir notas...',
                      alignLabelWithHint: true,
                    ),
              ),

              const SizedBox(height: 28),

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
                  onPressed: confirmarVenta,
                  child: const Text(
                    'Confirmar Venta',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.cardTitle.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }

          return null;
        },
        decoration: _inputDecoration(
          label: label,
          icon: icon,
        ).copyWith(hintText: hint),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: _inputDecoration(label: label, icon: icon),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: AppDimensions.inputBorderWidth,
        ),
      ),
    );
  }
}
