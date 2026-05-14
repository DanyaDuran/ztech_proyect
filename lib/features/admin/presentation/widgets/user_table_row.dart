import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../auth/domain/user_model.dart';

import 'user_status_badge.dart';

class UserTableRow extends StatelessWidget {
  final UserModel user;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const UserTableRow({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
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

          if (user.rol != 'superusuario')
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.secondary),

              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                }

                if (value == 'toggle') {
                  onToggleStatus();
                }

                if (value == 'delete') {
                  onDelete();
                }
              },

              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),

                PopupMenuItem(
                  value: 'toggle',
                  child: Text(user.activo ? 'Desactivar' : 'Activar'),
                ),

                const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
              ],
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
