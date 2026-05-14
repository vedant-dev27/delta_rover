import 'dart:async';

import 'package:flutter/material.dart';

import '../../../services/telemetry_service.dart';
import 'sensor_tile.dart';

class BottomSensorStrip extends StatefulWidget {
  const BottomSensorStrip({
    super.key,
    required this.ip,
  });

  final String ip;

  @override
  State<BottomSensorStrip> createState() => _BottomSensorStripState();
}

class _BottomSensorStripState extends State<BottomSensorStrip> {
  String accel = '--';
  String gyro = '--';

  Timer? timer;

  @override
  void initState() {
    super.initState();

    fetch();

    timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => fetch(),
    );
  }

  Future<void> fetch() async {
    final data = await TelemetryService.getData(
      widget.ip,
    );

    if (data == null || !mounted) return;

    final mpu = data['mpu'];

    final accelData = mpu['accel'];
    final gyroData = mpu['gyro'];

    setState(() {
      accel =
          'X:${accelData['x'].toStringAsFixed(1)} '
          'Y:${accelData['y'].toStringAsFixed(1)}';

      gyro =
          'X:${gyroData['x'].toStringAsFixed(1)} '
          'Y:${gyroData['y'].toStringAsFixed(1)}';
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: SensorTile(
            label: 'PIR 1',
            value: '--',
          ),
        ),

        const SizedBox(width: 8),

        const Expanded(
          child: SensorTile(
            label: 'PIR 2',
            value: '--',
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'ACCEL',
            value: accel,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'GYRO',
            value: gyro,
          ),
        ),
      ],
    );
  }
}
