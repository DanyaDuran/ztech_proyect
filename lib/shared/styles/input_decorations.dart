import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

InputDecoration customInputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,

    prefixIcon: Icon(icon, color: AppColors.primary),

    filled: true,
    fillColor: Colors.white,

    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),

      borderSide: BorderSide(color: Colors.grey.shade300),
    ),

    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),

      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
  );
}
