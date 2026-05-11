import 'package:flutter/material.dart';
import '../../../../shared/widgets/sidebar_menu.dart';
import '../../../bodega/data/mock_notebooks.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black54),
                onPressed: () => _mostrarMensajeDesarrollo(context),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF4A90E2),
              radius: 16,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildStatsCards(),
            
            // LÓGICA TAREA SCRUM-86: Mostrar alerta solo si stock < 5
            _checkAndBuildStockAlert(context),
            
            const SizedBox(height: 24),
            _buildMiddleSection(context),
            const SizedBox(height: 24),
            _buildRecentNotebooksTable(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Dashboard', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            SizedBox(height: 4),
            Text('Resumen general del sistema', style: TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _mostrarMensajeDesarrollo(context),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Exportar inventario CSV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.calendar_today_outlined, size: 16, color: Colors.black54),
                  SizedBox(width: 8),
                  Text('16 de noviembre de 2024', style: TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
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

  // MÉTODO SCRUM-86: Lógica condicional
  Widget _checkAndBuildStockAlert(BuildContext context) {
    final int disponibles = mockNotebooks.where((n) => n.estado == 'Disponible').length;
    
    if (disponibles < 5) {
      return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9E6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alerta de stock bajo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Quedan $disponibles notebooks disponibles. Se recomienda realizar una nueva compra.', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                ],
              ),
              OutlinedButton(
                onPressed: () => _mostrarMensajeDesarrollo(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Ver inventario'),
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink(); // No muestra nada si hay 5 o más
    }
  }

  Widget _buildMiddleSection(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildPieChartCard()),
          const SizedBox(width: 24),
          Expanded(child: _buildRecentActivityCard(context)),
        ],
      );
    } else {
      return Column(
        children: [
          _buildPieChartCard(),
          const SizedBox(height: 24),
          _buildRecentActivityCard(context),
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
                    colors: const [
                      Colors.green, Colors.green,
                      Colors.orange, Colors.orange,
                      Colors.blue, Colors.blue,
                      Colors.red, Colors.red
                    ],
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
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(BuildContext context) {
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
              const Text('Historial de cambios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => _mostrarMensajeDesarrollo(context),
                child: const Text('Ver todo', style: TextStyle(color: Colors.blue)),
              )
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

  Widget _buildRecentNotebooksTable(BuildContext context) {
    final recientes = mockNotebooks.take(5).toList();

    return Container(
      width: double.infinity,
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
              const Text('Últimos notebooks registrados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              OutlinedButton(
                onPressed: () => _mostrarMensajeDesarrollo(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Ver todos'),
              )
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              dataRowMaxHeight: 60,
              dataRowMinHeight: 60,
              columns: const [
                DataColumn(label: Text('Código interno')),
                DataColumn(label: Text('Marca / Modelo')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Ubicación')),
                DataColumn(label: Text('Fecha ingreso')),
              ],
              rows: recientes.map((n) {
                Color statusColor;
                switch (n.estado) {
                  case 'Disponible': statusColor = Colors.green; break;
                  case 'En reparación': statusColor = Colors.orange; break;
                  case 'Vendido': statusColor = Colors.blue; break;
                  case 'Merma': statusColor = Colors.red; break;
                  default: statusColor = Colors.grey;
                }
                
                String ubicacion = '${n.seccion} ${n.estante}-${n.nivel}';
                if (ubicacion.trim() == '- - -') ubicacion = 'No asignada';

                return _buildDataRow(
                  n.codigo,
                  '${n.marca} ${n.modelo}',
                  n.estado,
                  statusColor,
                  ubicacion,
                  '16/11/2024'
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String code, String model, String status, Color statusColor, String location, String date) {
    return DataRow(
      cells: [
        DataCell(Text(code, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(model)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        DataCell(Text(location)),
        DataCell(Text(date)),
      ],
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(count, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: iconColor)),
          const Spacer(),
          Row(
            children: [
              Icon(trendIcon, size: 14, color: trendColor),
              const SizedBox(width: 4),
              Expanded(child: Text(trendText, style: TextStyle(fontSize: 11, color: trendColor), overflow: TextOverflow.ellipsis)),
            ],
          ),
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
        )
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
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 24),
        ),
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