import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

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

        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textLight),

        prefixIcon: const Icon(Icons.search, color: AppColors.primary),

        filled: true,
        fillColor: AppColors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: AppColors.border),
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
      ),
    );
  }
}
