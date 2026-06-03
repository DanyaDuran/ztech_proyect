import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../bodega/domain/notebook_model.dart';
import '../../data/repositories/ventas_repository.dart';
import '../../data/services/comprobante_salida_pdf_service.dart';
import '../../domain/venta_model.dart';

class RegistrarVentaScreen extends StatefulWidget {
  final NotebookModel notebook;
  final Future<void> Function() onConfirmarVenta;

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
  final VentaRepository ventaRepository = VentaRepository();

  final clienteController = TextEditingController();
  final telefonoController = TextEditingController();
  final precioController = TextEditingController();
  final notasController = TextEditingController();

  String formaPago = 'Transferencia';
  bool isSaving = false;

  @override
  void dispose() {
    clienteController.dispose();
    telefonoController.dispose();
    precioController.dispose();
    notasController.dispose();
    super.dispose();
  }

  String? validarNombreCompleto(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'El nombre completo es obligatorio';

    final partes = text.split(' ').where((p) => p.isNotEmpty).toList();

    if (partes.length < 2) return 'Ingresa nombre y apellido';

    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(text)) {
      return 'El nombre solo debe contener letras';
    }

    return null;
  }

  String? validarTelefono(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'El teléfono es obligatorio';

    if (!RegExp(r'^9\s?\d{8}$').hasMatch(text)) {
      return 'Formato válido: 9 40503233';
    }

    return null;
  }

  String? validarPrecio(String? value) {
    final text = value?.replaceAll('.', '').trim() ?? '';

    if (text.isEmpty) return 'El precio es obligatorio';

    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return 'El precio solo debe contener números';
    }

    if (int.parse(text) <= 0) return 'El precio debe ser mayor a 0';

    return null;
  }

  Future<void> confirmarVenta() async {
    if (isSaving) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final venta = VentaModel(
        notebook: widget.notebook,
        cliente: clienteController.text.trim(),
        telefono: telefonoController.text.trim(),
        precio: precioController.text.replaceAll('.', '').trim(),
        formaPago: formaPago,
        notas: notasController.text.trim(),
        fechaVenta: DateTime.now(),
      );

      await ventaRepository.addVenta(venta);

      if (!mounted) return;

      await widget.onConfirmarVenta();

      if (!mounted) return;

      await ComprobanteSalidaPdfService().generarComprobanteSalida(
        notebook: widget.notebook,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venta registrada correctamente')),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al registrar venta: $e')));
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
                label: 'Nombre completo',
                hint: 'Ej: Juan Pérez',
                icon: Icons.person_outline,
                validator: validarNombreCompleto,
              ),

              _buildTextField(
                controller: telefonoController,
                label: 'Teléfono',
                hint: 'Ej: 9 40503233',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: validarTelefono,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
                  LengthLimitingTextInputFormatter(10),
                ],
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
                hint: 'Ej: 650.000',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: validarPrecio,
                inputFormatters: [PrecioInputFormatter()],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<String>(
                  initialValue: formaPago,
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
                  onChanged: isSaving
                      ? null
                      : (value) {
                          setState(() {
                            formaPago = value!;
                          });
                        },
                ),
              ),

              TextFormField(
                controller: notasController,
                maxLines: 3,
                maxLength: 180,
                inputFormatters: [LengthLimitingTextInputFormatter(180)],
                decoration:
                    _inputDecoration(
                      label: 'Notas opcionales',
                      icon: Icons.notes_outlined,
                    ).copyWith(
                      hintText: 'Añadir notas...',
                      alignLabelWithHint: true,
                      counterText: '',
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
                  onPressed: isSaving ? null : confirmarVenta,
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
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
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        enabled: !isSaving,
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

class PrecioInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final reversed = digits.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(reversed[i]);
    }

    final formatted = buffer.toString().split('').reversed.join();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
