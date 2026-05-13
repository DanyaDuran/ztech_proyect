import 'package:flutter/material.dart';
import '../../styles/input_decorations.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
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

        decoration: customInputDecoration(
          label: label,
          icon: icon,
        ).copyWith(hintText: hint),
      ),
    );
  }
}
