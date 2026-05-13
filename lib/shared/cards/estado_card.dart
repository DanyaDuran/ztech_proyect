import 'package:flutter/material.dart';

class EstadoCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const EstadoCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: Colors.grey.shade300),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Text(
            title,

            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),

          const SizedBox(height: 4),

          Icon(Icons.remove, size: 14, color: color),

          const SizedBox(height: 4),

          Text(
            count.toString(),

            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
