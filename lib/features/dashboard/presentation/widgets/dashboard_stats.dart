import 'package:flutter/material.dart';
import '../../../bodega/data/mock_notebooks.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    final int disponibles = mockNotebooks.where((n) => n.estado == 'Disponible').length;
    final int enReparacion = mockNotebooks.where((n) => n.estado == 'En reparación').length;
    final int vendidos = mockNotebooks.where((n) => n.estado == 'Vendido').length;
    final int merma = mockNotebooks.where((n) => n.estado == 'Merma').length;

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: constraints.maxWidth < 600 ? 0.95 : 1.1,
          children: [
            _StatCard(title: 'Disponibles', count: disponibles.toString(), icon: Icons.laptop_chromebook, iconColor: Colors.green, trendText: '12% vs mes anterior', trendIcon: Icons.arrow_outward, trendColor: Colors.green),
            _StatCard(title: 'En reparación', count: enReparacion.toString(), icon: Icons.build_outlined, iconColor: Colors.orange, trendText: '5% vs mes anterior', trendIcon: Icons.arrow_downward, trendColor: Colors.orange),
            _StatCard(title: 'Vendidos', count: vendidos.toString(), icon: Icons.shopping_cart_outlined, iconColor: Colors.blue, trendText: '8% vs mes anterior', trendIcon: Icons.arrow_outward, trendColor: Colors.green),
            _StatCard(title: 'Merma', count: merma.toString(), icon: Icons.warning_amber_rounded, iconColor: Colors.red, trendText: '0% vs mes anterior', trendIcon: Icons.arrow_outward, trendColor: Colors.red),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconColor;
  final String trendText;
  final IconData trendIcon;
  final Color trendColor;

  const _StatCard({required this.title, required this.count, required this.icon, required this.iconColor, required this.trendText, required this.trendIcon, required this.trendColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 28)),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(count, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: iconColor)),
          const Spacer(),
          Row(children: [Icon(trendIcon, size: 14, color: trendColor), const SizedBox(width: 4), Expanded(child: Text(trendText, style: TextStyle(fontSize: 11, color: trendColor), overflow: TextOverflow.ellipsis))]),
        ],
      ),
    );
  }
}