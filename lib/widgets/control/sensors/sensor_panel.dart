import 'package:flutter/material.dart';

import 'sensor_tile.dart';

class SensorPanel extends StatelessWidget {
  const SensorPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: SensorTile(
                label: 'TEMP',
                value: '--',
              ),
            ),

            SizedBox(width: 8),

            Expanded(
              child: SensorTile(
                label: 'HUMIDITY',
                value: '--',
              ),
            ),

            SizedBox(width: 8),

            Expanded(
              child: SensorTile(
                label: 'PIR 1',
                value: '--',
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        Row(
          children: const [
            Expanded(
              child: SensorTile(
                label: 'PIR 2',
                value: '--',
              ),
            ),

            SizedBox(width: 8),

            Expanded(
              child: SensorTile(
                label: 'ULTRA 1',
                value: '--',
              ),
            ),

            SizedBox(width: 8),

            Expanded(
              child: SensorTile(
                label: 'ULTRA 2',
                value: '--',
              ),
            ),

            SizedBox(width: 8),

            Expanded(
              child: SensorTile(
                label: 'ULTRA 3',
                value: '--',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
