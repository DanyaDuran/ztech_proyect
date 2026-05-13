import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar/sidebar_menu.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/stock_alert.dart';
import '../widgets/dashboard_middle_section.dart';
import '../widgets/recent_notebooks_table.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _mostrarMensajeDesarrollo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad en desarrollo (Próximo Sprint)'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF1E293B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const SidebarMenu(currentRoute: '/dashboard'),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(onShowMessage: () => _mostrarMensajeDesarrollo(context)),
            const SizedBox(height: 24),
            const DashboardStats(),
            StockAlert(onShowMessage: () => _mostrarMensajeDesarrollo(context)),
            const SizedBox(height: 24),
            DashboardMiddleSection(onShowMessage: () => _mostrarMensajeDesarrollo(context)),
            const SizedBox(height: 24),
            const RecentNotebooksTable(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black87),
      actions: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFF4A90E2), 
            radius: 16, 
            child: Icon(Icons.person, color: Colors.white, size: 20)
          ),
        ),
      ],
    );
  }
}