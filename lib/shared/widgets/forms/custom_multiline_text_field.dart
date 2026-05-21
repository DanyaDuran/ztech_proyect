import 'package:flutter/material.dart';

import '../../styles/input_decorations.dart';

class CustomMultilineTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomMultilineTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      validator: validator,
      textInputAction: TextInputAction.newline,
      decoration: customInputDecoration(
        label: label,
        icon: icon,
      ).copyWith(hintText: hint, alignLabelWithHint: true),
    );
  }
}
