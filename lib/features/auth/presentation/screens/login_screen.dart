import 'package:flutter/material.dart';

import '../../data/mock_users.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../shared/styles/input_decorations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _login() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      _showMessage('Revisa los campos del formulario');
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final user = mockUsers.where((user) => user.correo == email).firstOrNull;

    if (user == null) {
      _showMessage('El correo ingresado no existe');
      return;
    }

    if (!user.activo) {
      _showMessage('La cuenta se encuentra desactivada');
      return;
    }

    if (user.password != password) {
      _showMessage('La contraseña es incorrecta');
      return;
    }

    _showMessage('Inicio de sesión con éxito');

    final Map<String, String> roleRoutes = {
      'admin': '/dashboard',
      'bodega': '/bodega',
      'tecnico': '/tecnico',
      'ventas': '/ventas',
      'superusuario': '/admin',
    };

    final route = roleRoutes[user.rol] ?? '/dashboard';

    Navigator.pushReplacementNamed(context, route);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo_ztech.png',
                    width: 95,
                    height: 95,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Ztech',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Gestión eficiente de notebooks',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 36),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: customInputDecoration(
                      label: 'Correo electrónico',
                      icon: Icons.email_outlined,
                    ),
                    validator: AppValidators.email,
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: AppValidators.password,
                  ),

                  const SizedBox(height: 14),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _showMessage('Función de recuperación pendiente');
                      },
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: _login,
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    '© ZTech Inventory System',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
