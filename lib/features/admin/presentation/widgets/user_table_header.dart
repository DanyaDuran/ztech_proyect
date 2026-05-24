import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';

class UserTableHeader extends StatelessWidget {
  const UserTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Nombre', style: AppTextStyles.cardTitle),
          ),
          Expanded(
            flex: 2,
            child: Text('Correo', style: AppTextStyles.cardTitle),
          ),
          Expanded(child: Text('Rol', style: AppTextStyles.cardTitle)),
          Expanded(child: Text('Estado', style: AppTextStyles.cardTitle)),
          SizedBox(
            width: 70,
            child: Text('Acción', style: AppTextStyles.cardTitle),
          ),
        ],
      ),
    );
  }
}
