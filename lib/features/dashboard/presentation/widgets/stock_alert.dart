import 'package:flutter/material.dart';
import '../../../bodega/data/mock_notebooks.dart';

class StockAlert extends StatelessWidget {
  final VoidCallback onShowMessage;

  const StockAlert({super.key, required this.onShowMessage});

  @override
  Widget build(BuildContext context) {
    final int disponibles = mockNotebooks.where((n) => n.estado == 'Disponible').length;

    if (disponibles < 5) {
      return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFFFF9E6), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFFE082))),
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
                onPressed: onShowMessage,
                style: OutlinedButton.styleFrom(foregroundColor: Colors.orange, side: const BorderSide(color: Colors.orange), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Ver inventario'),
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}