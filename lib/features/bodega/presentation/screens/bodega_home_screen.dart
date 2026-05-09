import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar_menu.dart';

class BodegaHomeScreen extends StatelessWidget {
  const BodegaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarMenu(currentRoute: '/bodega'),
      appBar: AppBar(title: const Text('Bodega')),
      body: const Center(child: Text('Módulo Bodega en desarrollo')),
    );
  }
}
