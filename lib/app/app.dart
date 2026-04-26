import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
// 1. Importamos el archivo de nuestro nuevo botón
import '../core/widgets/custom_action_button.dart';

class ZTechApp extends StatelessWidget {
  const ZTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZTech Inventory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // 2. Quitamos la palabra "const" antes de Scaffold
      home: Scaffold(
        body: Center(
          // 3. Usamos un Column para poner el texto y el botón uno debajo del otro
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ZTech Inventory App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // Espacio en blanco para separar
              
              // 4. Implementamos tu botón personalizado
              CustomActionButton(
                text: 'Probar Botón',
                icon: Icons.check_circle,
                onPressed: () {
                  // Esta acción imprime un mensaje en la consola de depuración
                  debugPrint('¡El botón funciona correctamente!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}