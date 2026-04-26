import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_colors.dart';
import '../core/widgets/custom_button.dart';

class ZTechApp extends StatelessWidget {
  const ZTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZTech Inventario',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ZTech Inventory App',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Probar Conexión',
                onPressed: () {
                  debugPrint('El botón funciona correctamente');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}