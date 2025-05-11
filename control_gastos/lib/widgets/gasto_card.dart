import 'package:flutter/material.dart';
import '../models/gasto.dart';

class GastoCard extends StatelessWidget {
  final Gasto gasto;
  final VoidCallback? onTap;

  const GastoCard({
    super.key,
    required this.gasto,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gasto.descripcion,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                gasto.categoria,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${gasto.monto.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                gasto.fecha.toLocal().toString().split(' ')[0],
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}