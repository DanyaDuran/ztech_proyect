import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar_menu.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarMenu(currentRoute: '/dashboard'),
      appBar: AppBar(title: const Text('Dashboard administrador')),
      body: const Center(child: Text('Pantalla Dashboard')),
    );
  }
}
