import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../styles/input_decorations.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final List<String> items;
  final String hint;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        dropdownColor: Colors.white,
        style: const TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.w500,
        ),
        iconEnabledColor: AppColors.primary,
        decoration: customInputDecoration(
          label: label,
          icon: icon,
        ).copyWith(hintText: hint, alignLabelWithHint: true),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: validator ?? _defaultValidator,
      ),
    );
  }

  static String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Obligatorio';
    }

    return null;
  }
}
