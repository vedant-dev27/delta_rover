import 'package:flutter/material.dart';

import 'sensor_tile.dart';

class BottomSensorStrip extends StatelessWidget {
  const BottomSensorStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: SensorTile(
            label: 'PIR 1',
            value: '--',
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'PIR 2',
            value: '--',
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'ACCEL',
            value: '--',
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'GYRO',
            value: '--',
          ),
        ),
      ],
    );
  }
}
