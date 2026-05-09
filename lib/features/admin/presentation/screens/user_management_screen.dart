import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar_menu.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarMenu(currentRoute: '/admin'),
      appBar: AppBar(title: const Text('Gestión de usuarios')),
      body: const Center(child: Text('Módulo Usuarios en desarrollo')),
    );
  }
}
