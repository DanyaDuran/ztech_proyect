import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';
import 'package:ztech_flutter__app/shared/widgets/app_bar/custom_app_bar.dart';
import 'package:ztech_flutter__app/shared/widgets/sidebar/sidebar_menu.dart';
import 'package:ztech_flutter__app/features/auth/domain/user_model.dart';
import 'package:ztech_flutter__app/features/auth/data/services/user_firestore_service.dart';
import 'package:ztech_flutter__app/features/admin/presentation/widgets/user_table_header.dart';
import 'package:ztech_flutter__app/features/admin/presentation/widgets/user_table_row.dart';

import 'user_form_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final UserFirestoreService _userService = UserFirestoreService();
  final TextEditingController _searchController = TextEditingController();

  String _selectedRole = 'todos';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> _applyFilters(List<UserModel> users) {
    final search = _searchController.text.trim().toLowerCase();

    return users.where((user) {
      final matchesSearch =
          user.nombre.toLowerCase().contains(search) ||
          user.correo.toLowerCase().contains(search) ||
          user.rol.toLowerCase().contains(search);

      final matchesRole = _selectedRole == 'todos' || user.rol == _selectedRole;

      return matchesSearch && matchesRole;
    }).toList();
  }

  Future<void> _openCreateUserScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const UserFormScreen()),
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario creado correctamente')),
      );
    }
  }

  Future<void> _openEditUserScreen(UserModel user) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => UserFormScreen(userToEdit: user)),
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario actualizado correctamente')),
      );
    }
  }

  Future<void> _toggleUserStatus(UserModel user) async {
    await _userService.actualizarEstadoUsuario(
      uid: user.id,
      activo: !user.activo,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Estado del usuario actualizado')),
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
                    controller: _searchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar usuario...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                      suffixIcon: PopupMenuButton<String>(
                        tooltip: 'Filtrar por rol',
                        icon: const Icon(
                          Icons.filter_alt_outlined,
                          color: AppColors.secondary,
                        ),
                        onSelected: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'todos',
                            child: Text('Todos los roles'),
                          ),
                          PopupMenuItem(
                            value: 'super_admin',
                            child: Text('Super Admin'),
                          ),
                          PopupMenuItem(value: 'admin', child: Text('Admin')),
                          PopupMenuItem(value: 'bodega', child: Text('Bodega')),
                          PopupMenuItem(
                            value: 'tecnico',
                            child: Text('Técnico'),
                          ),
                          PopupMenuItem(value: 'ventas', child: Text('Ventas')),
                        ],
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
                  child: StreamBuilder<List<UserModel>>(
                    stream: _userService.obtenerUsuarios(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('Error al cargar usuarios'),
                        );
                      }

                      final users = _applyFilters(snapshot.data ?? []);

                      if (users.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No hay usuarios que coincidan'),
                        );
                      }

                      return Column(
                        children: [
                          const UserTableHeader(),
                          ...users.map((user) {
                            return UserTableRow(
                              user: user,
                              onEdit: () => _openEditUserScreen(user),
                              onToggleStatus: () => _toggleUserStatus(user),
                            );
                          }),
                        ],
                      );
                    },
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
