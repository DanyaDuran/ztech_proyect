import 'package:flutter/material.dart';
import '../../../bodega/data/mock_notebooks.dart';

class DashboardMiddleSection extends StatelessWidget {
  final VoidCallback onShowMessage;

  const DashboardMiddleSection({super.key, required this.onShowMessage});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildPieChartCard()),
          const SizedBox(width: 24),
          Expanded(child: _buildRecentActivityCard()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildPieChartCard(),
          const SizedBox(height: 24),
          _buildRecentActivityCard(),
        ],
      );
    }
  }

  Widget _buildPieChartCard() {
    final int total = mockNotebooks.length;
    final int disp = mockNotebooks.where((n) => n.estado == 'Disponible').length;
    final int rep = mockNotebooks.where((n) => n.estado == 'En reparación').length;
    final int ven = mockNotebooks.where((n) => n.estado == 'Vendido').length;
    final int mer = mockNotebooks.where((n) => n.estado == 'Merma').length;

    String pct(int value) => total == 0 ? '0' : ((value / total) * 100).toStringAsFixed(0);

    double totalGrafico = (disp + rep + ven + mer).toDouble();
    if (totalGrafico == 0) totalGrafico = 1;

    double stop1 = disp / totalGrafico;
    double stop2 = stop1 + (rep / totalGrafico);
    double stop3 = stop2 + (ven / totalGrafico);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notebooks por estado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    stops: [0.0, stop1, stop1, stop2, stop2, stop3, stop3, 1.0],
                    colors: const [Colors.green, Colors.green, Colors.orange, Colors.orange, Colors.blue, Colors.blue, Colors.red, Colors.red],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Total', style: TextStyle(color: Colors.black54, fontSize: 14)),
                        Text('$total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(color: Colors.green, title: 'Disponibles', subtitle: '$disp (${pct(disp)}%)'),
                  const SizedBox(height: 12),
                  _LegendItem(color: Colors.orange, title: 'En reparación', subtitle: '$rep (${pct(rep)}%)'),
                  const SizedBox(height: 12),
                  _LegendItem(color: Colors.blue, title: 'Vendidos', subtitle: '$ven (${pct(ven)}%)'),
                  const SizedBox(height: 12),
                  _LegendItem(color: Colors.red, title: 'Merma', subtitle: '$mer (${pct(mer)}%)'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('Historial de cambios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              TextButton(onPressed: onShowMessage, child: const Text('Ver todo', style: TextStyle(color: Colors.blue))),
            ],
          ),
          const SizedBox(height: 16),
          const _ActivityItem(icon: Icons.laptop_chromebook, iconColor: Colors.green, title: 'Notebook ASUS X515 ingresado a bodega', subtitle: 'Por David C.', time: 'Hoy\n10:30'),
          const Divider(height: 24),
          const _ActivityItem(icon: Icons.build_outlined, iconColor: Colors.orange, title: 'Notebook Lenovo L14 en reparación', subtitle: 'Por Técnico 1', time: 'Hoy\n09:15'),
          const Divider(height: 24),
          const _ActivityItem(icon: Icons.shopping_cart_outlined, iconColor: Colors.blue, title: 'Venta realizada - HP 240 G8', subtitle: 'Por Giuliana R.', time: 'Ayer\n16:45'),
          const Divider(height: 24),
          const _ActivityItem(icon: Icons.warning_amber_rounded, iconColor: Colors.red, title: 'Notebook Dell Latitude dado de baja', subtitle: 'Por Aaron M.', time: 'Ayer\n11:20'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;

  const _LegendItem({required this.color, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 24)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(time, textAlign: TextAlign.right, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    );
  }
}