import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar_menu.dart';

class VentasHomeScreen extends StatelessWidget {
  const VentasHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarMenu(currentRoute: '/ventas'),
      appBar: AppBar(title: const Text('Ventas')),
      body: const Center(child: Text('Módulo Ventas en desarrollo')),
    );
  }
}
