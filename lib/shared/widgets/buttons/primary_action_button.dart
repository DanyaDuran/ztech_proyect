import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/app_colors.dart';

class PrimaryActionButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final String loadingText;
  final IconData icon;
  final VoidCallback? onPressed;

  const PrimaryActionButton({
    super.key,
    required this.isLoading,
    required this.text,
    required this.loadingText,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(icon),
        label: Text(
          isLoading ? loadingText : text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
