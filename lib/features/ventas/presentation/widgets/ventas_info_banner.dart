import 'package:flutter/material.dart';

class VentasInfoBanner extends StatelessWidget {
  const VentasInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade100),
      ),

      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.green.shade700, size: 20),

          const SizedBox(width: 8),

          Text(
            'Solo se muestran notebooks disponibles para venta.',

            style: TextStyle(color: Colors.green.shade800, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
