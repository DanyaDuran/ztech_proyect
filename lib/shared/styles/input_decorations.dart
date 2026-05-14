import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

InputDecoration customInputDecoration({
  required String label,
  required IconData icon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: AppTextStyles.body,
    prefixIcon: Icon(icon, color: AppColors.primary),

    suffixIcon: suffixIcon,

    filled: true,
    fillColor: AppColors.white,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      borderSide: BorderSide(color: AppColors.border),
    ),

    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppDimensions.radiusMedium),
      ),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
  );
}
