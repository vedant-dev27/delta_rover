import 'package:flutter/material.dart';

import 'mpu_row.dart';

class MpuTable extends StatelessWidget {
  const MpuTable({
    super.key,
    required this.ax,
    required this.ay,
    required this.az,
    required this.gx,
    required this.gy,
    required this.gz,
  });

  final String ax;
  final String ay;
  final String az;

  final String gx;
  final String gy;
  final String gz;

  Widget heading(String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B3B40),
          width: 1.2,
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Row(
            children: [
              const SizedBox(width: 42),

              heading('X'),
              heading('Y'),
              heading('Z'),
            ],
          ),

          const SizedBox(height: 8),

          MpuRow(
            label: 'ACC',
            x: ax,
            y: ay,
            z: az,
          ),

          const SizedBox(height: 6),

          MpuRow(
            label: 'GYR',
            x: gx,
            y: gy,
            z: gz,
          ),
        ],
      ),
    );
  }
}
