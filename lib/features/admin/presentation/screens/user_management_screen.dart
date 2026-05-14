import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../../../auth/domain/user_model.dart';
import '../../data/user_repository.dart';
import '../../domain/user_service.dart';
import '../widgets/user_table_header.dart';
import '../widgets/user_table_row.dart';
import 'user_form_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late UserRepository repository;
  late UserService service;

  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    repository = UserRepository();
    service = UserService(repository);
    users = service.getUsers();
  }

  void _refreshUsers() {
    setState(() {
      users = service.getUsers();
    });
  }

  Future<void> _openCreateUserScreen() async {
    final result = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(builder: (_) => const UserFormScreen()),
    );

    if (!mounted) return;

    if (result != null) {
      final created = service.createUser(result);

      if (created) {
        _refreshUsers();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo crear el usuario')),
        );
      }
    }
  }

  Future<void> _openEditUserScreen(int index, UserModel user) async {
    final result = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(builder: (_) => UserFormScreen(userToEdit: user)),
    );

    if (!mounted) return;

    if (result != null) {
      service.updateUser(index: index, updatedUser: result);

      _refreshUsers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario actualizado correctamente')),
      );
    }
  }

  void _toggleUserStatus(int index) {
    service.toggleUserStatus(index);
    _refreshUsers();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Estado del usuario actualizado')),
    );
  }

  void _confirmDeleteUser(int index) {
    final user = users[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Deseas eliminar la cuenta de ${user.nombre}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.statusDiscarded,
                foregroundColor: AppColors.textOnDark,
              ),
              onPressed: () {
                service.deleteUser(index);
                _refreshUsers();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuario eliminado correctamente'),
                  ),
                );
              },
              child: const Text('Sí, eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SidebarMenu(currentRoute: '/admin'),
      appBar: const CustomAppBar(title: 'Gestión de Usuarios'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usuarios registrados en el sistema',
              style: AppTextStyles.subtitle,
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar usuario...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: AppDimensions.spacingMedium),

                ElevatedButton.icon(
                  onPressed: _openCreateUserScreen,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Nuevo usuario'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnDark,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.buttonHorizontalPadding,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 900,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const UserTableHeader(),

                      ...users.asMap().entries.map((entry) {
                        final index = entry.key;
                        final user = entry.value;

                        return UserTableRow(
                          user: user,
                          onEdit: () => _openEditUserScreen(index, user),
                          onDelete: () => _confirmDeleteUser(index),
                          onToggleStatus: () => _toggleUserStatus(index),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
