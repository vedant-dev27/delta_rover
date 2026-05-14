import 'package:flutter/material.dart';

class MpuRow extends StatelessWidget {
  const MpuRow({
    super.key,
    required this.label,
    required this.x,
    required this.y,
    required this.z,
  });

  final String label;

  final String x;
  final String y;
  final String z;

  Widget cell(String value) {
    return Expanded(
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),

        cell(x),
        cell(y),
        cell(z),
      ],
    );
  }
}
