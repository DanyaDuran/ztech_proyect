import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';

class TecnicoHomeScreen extends StatelessWidget {
  const TecnicoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarMenu(currentRoute: '/tecnico'),
      appBar: AppBar(title: const Text('Técnico')),
      body: const Center(child: Text('Módulo Técnico en desarrollo')),
    );
  }
}
