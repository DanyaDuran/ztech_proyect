import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ztech_flutter__app/core/theme/theme.dart';

import 'package:ztech_flutter__app/features/auth/domain/user_model.dart';
import 'package:ztech_flutter__app/features/auth/data/services/user_firestore_service.dart';
import 'package:ztech_flutter__app/features/admin/domain/user_service.dart';

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

  final UserFirestoreService _firestoreService = UserFirestoreService();
  final UserService _userService = UserService();

  String _rolSeleccionado = 'admin';
  bool _activo = true;
  bool _isLoading = false;

  final List<String> _rolesPermitidos = [
    'admin',
    'bodega',
    'tecnico',
    'ventas',
  ];

  bool get isEditing => widget.userToEdit != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      _nombreController.text = widget.userToEdit!.nombre;
      _correoController.text = widget.userToEdit!.correo;
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

  Future<void> _guardarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreController.text.trim();
    final correo = _correoController.text.trim();
    final password = _passwordController.text.trim();

    final validation = _userService.validateUser(
      nombre: nombre,
      correo: correo,
      rol: _rolSeleccionado,
      password: password,
      isEditing: isEditing,
    );

    if (validation != null) {
      _showMessage(validation);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (isEditing) {
        final updatedUser = UserModel(
          id: widget.userToEdit!.id,
          nombre: nombre,
          correo: correo,
          rol: _rolSeleccionado,
          activo: _activo,
        );

        await _firestoreService.actualizarUsuario(updatedUser);

        if (!mounted) return;
        Navigator.pop(context, true);
        return;
      }

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: correo, password: password);

      final uid = credential.user!.uid;

      await _firestoreService.crearUsuarioFirestore(
        uid: uid,
        nombre: nombre,
        correo: correo,
        rol: _rolSeleccionado,
        activo: _activo,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showMessage('El correo ya existe');
      } else if (e.code == 'weak-password') {
        _showMessage('La contraseña es muy débil');
      } else {
        _showMessage('No se pudo crear el usuario');
      }
    } catch (e) {
      _showMessage('Ocurrió un error al guardar el usuario');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  ),

                  const SizedBox(height: AppDimensions.inputSpacing),

                  TextFormField(
                    controller: _correoController,
                    enabled: !isEditing,
                    keyboardType: TextInputType.emailAddress,

                    decoration: const InputDecoration(
                      labelText: 'Correo',

                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.inputSpacing),
                  if (!isEditing)
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                  if (!isEditing)
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
                      onPressed: _isLoading ? null : _guardarUsuario,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
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
