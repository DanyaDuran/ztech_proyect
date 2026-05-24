import 'package:flutter/material.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';

import 'package:ztech_flutter__app/features/auth/domain/user_model.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? userToEdit;

  const UserFormScreen({super.key, this.userToEdit});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();

  final TextEditingController _correoController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String _rolSeleccionado = 'admin';

  bool _activo = true;

  final List<String> _rolesPermitidos = [
    'admin',
    'bodega',
    'tecnico',
    'ventas',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.userToEdit != null) {
      _nombreController.text = widget.userToEdit!.nombre;

      _correoController.text = widget.userToEdit!.correo;

      _passwordController.text = widget.userToEdit!.password;

      _rolSeleccionado = widget.userToEdit!.rol;

      _activo = widget.userToEdit!.activo;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();

    _correoController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  void _guardarUsuario() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nuevoUsuario = UserModel(
      nombre: _nombreController.text.trim(),

      correo: _correoController.text.trim(),

      password: _passwordController.text.trim(),

      rol: _rolSeleccionado,

      activo: _activo,
    );

    Navigator.pop(context, nuevoUsuario);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.userToEdit != null;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.secondary,

        foregroundColor: AppColors.textOnDark,

        title: Text(
          isEditing ? 'Editar Usuario' : 'Nuevo Usuario',

          style: AppTextStyles.appBarTitle,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),

        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),

            padding: const EdgeInsets.all(AppDimensions.screenPadding),

            decoration: BoxDecoration(
              color: AppColors.surface,

              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),

              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,

                  blurRadius: 10,

                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    isEditing
                        ? 'Editar información del usuario'
                        : 'Crear nuevo usuario',

                    style: AppTextStyles.sectionTitle,
                  ),

                  const SizedBox(height: AppDimensions.sectionSpacing),

                  TextFormField(
                    controller: _nombreController,

                    decoration: const InputDecoration(
                      labelText: 'Nombre',

                      prefixIcon: Icon(Icons.person_outline),
                    ),

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese un nombre';
                      }

                      if (value.trim().length < 3) {
                        return 'Mínimo 3 caracteres';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: AppDimensions.inputSpacing),

                  TextFormField(
                    controller: _correoController,

                    keyboardType: TextInputType.emailAddress,

                    decoration: const InputDecoration(
                      labelText: 'Correo',

                      prefixIcon: Icon(Icons.email_outlined),
                    ),

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese un correo';
                      }

                      if (!value.contains('@')) {
                        return 'Correo inválido';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: AppDimensions.inputSpacing),

                  TextFormField(
                    controller: _passwordController,

                    obscureText: true,

                    decoration: const InputDecoration(
                      labelText: 'Contraseña',

                      prefixIcon: Icon(Icons.lock_outline),
                    ),

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese una contraseña';
                      }

                      if (value.trim().length < 6) {
                        return 'Mínimo 6 caracteres';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: AppDimensions.inputSpacing),

                  DropdownButtonFormField<String>(
                    initialValue: _rolSeleccionado,

                    decoration: const InputDecoration(
                      labelText: 'Rol',

                      prefixIcon: Icon(Icons.badge_outlined),
                    ),

                    items: _rolesPermitidos.map((rol) {
                      return DropdownMenuItem(value: rol, child: Text(rol));
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        _rolSeleccionado = value!;
                      });
                    },
                  ),

                  const SizedBox(height: AppDimensions.inputSpacing),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,

                    value: _activo,

                    activeThumbColor: AppColors.primary,

                    title: const Text(
                      'Usuario activo',

                      style: AppTextStyles.body,
                    ),

                    onChanged: (value) {
                      setState(() {
                        _activo = value;
                      });
                    },
                  ),

                  const SizedBox(height: AppDimensions.sectionSpacing),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: _guardarUsuario,

                      icon: const Icon(Icons.save_outlined),

                      label: Text(
                        isEditing ? 'Guardar cambios' : 'Guardar usuario',
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,

                        foregroundColor: AppColors.textOnDark,

                        elevation: 0,

                        padding: const EdgeInsets.symmetric(vertical: 18),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
