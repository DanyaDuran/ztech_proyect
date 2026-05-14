import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

class EstadoCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const EstadoCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),

      decoration: BoxDecoration(
        color: AppColors.white,

        border: Border.all(color: AppColors.border),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Text(
            title,

            style: AppTextStyles.badge.copyWith(color: color, fontSize: 10),
          ),

          const SizedBox(height: 4),

          Icon(Icons.remove, size: AppDimensions.iconSmall, color: color),

          const SizedBox(height: 4),

          Text(
            count.toString(),

            style: AppTextStyles.statusCount.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
