import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';

import '../../../auth/domain/user_model.dart';

import 'user_status_badge.dart';

class UserTableRow extends StatelessWidget {
  final UserModel user;

  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const UserTableRow({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: 18,
      ),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),

      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(user.nombre, style: AppTextStyles.body),
          ),

          Expanded(
            flex: 2,
            child: Text(user.correo, style: AppTextStyles.body),
          ),

          Expanded(child: Text(user.rol, style: AppTextStyles.body)),

          Expanded(child: UserStatusBadge(activo: user.activo)),

          if (user.rol != 'super_admin')
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.secondary),

              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                }

                if (value == 'toggle') {
                  onToggleStatus();
                }
              },

              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),

                PopupMenuItem(
                  value: 'toggle',
                  child: Text(user.activo ? 'Desactivar' : 'Activar'),
                ),
              ],
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
