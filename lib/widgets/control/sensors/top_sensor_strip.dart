import 'package:flutter/material.dart';

import 'sensor_tile.dart';

class TopSensorStrip extends StatelessWidget {
  const TopSensorStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: SensorTile(
            label: 'U1',
            value: '--',
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'U2',
            value: '--',
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'U3',
            value: '--',
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'TEMP',
            value: '--',
          ),
        ),

        SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'HUM',
            value: '--',
          ),
        ),
      ],
    );
  }
}
