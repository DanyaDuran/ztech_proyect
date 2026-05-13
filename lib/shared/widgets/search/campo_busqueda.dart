import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CampoBusqueda extends StatelessWidget {
  final Function(String) onChanged;
  final String hint;

  const CampoBusqueda({super.key, required this.onChanged, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(color: Color(0xFF9AA9B5)),

        prefixIcon: const Icon(Icons.search, color: AppColors.primary),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
