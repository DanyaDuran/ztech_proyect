import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/helpers/notebook_status_helper.dart';
import 'package:ztech_flutter__app/core/theme/theme.dart';
import 'package:ztech_flutter__app/features/bodega/data/repositories/notebook_repository.dart';
import 'package:ztech_flutter__app/features/bodega/domain/notebook_model.dart';

class StockAlert extends StatelessWidget {
  final VoidCallback onShowMessage;

  const StockAlert({super.key, required this.onShowMessage});

  @override
  Widget build(BuildContext context) {
    final repository = NotebookRepository();

    return StreamBuilder<List<NotebookModel>>(
      stream: repository.getNotebooks(),
      builder: (context, snapshot) {
        final notebooks = snapshot.data ?? [];

        final disponibles = NotebookStatusHelper.countByStatus(
          notebooks,
          NotebookStatusHelper.disponible,
        );

        if (snapshot.connectionState == ConnectionState.waiting ||
            disponibles >= 5) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.sectionSpacing),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            decoration: BoxDecoration(
              color: AppColors.statusRepair.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: AppColors.statusRepair.withValues(alpha: 0.45),
              ),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppDimensions.inputSpacing,
              runSpacing: AppDimensions.inputSpacing,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.statusRepair,
                  size: 32,
                ),
                Text(
                  'Quedan $disponibles notebooks disponibles.',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
