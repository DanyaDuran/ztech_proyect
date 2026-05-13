import 'package:flutter/material.dart';
import '../../../bodega/data/mock_notebooks.dart';

class RecentNotebooksTable extends StatelessWidget {
  const RecentNotebooksTable({super.key});

  @override
  Widget build(BuildContext context) {
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              const Text('Últimos notebooks registrados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              OutlinedButton(onPressed: () {}, child: const Text('Ver todos')),
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

                return _buildDataRow(n.codigo, '${n.marca} ${n.modelo}', n.estado, statusColor, ubicacion, '16/11/2024');
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
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        DataCell(Text(location)),
        DataCell(Text(date)),
      ],
    );
  }
}