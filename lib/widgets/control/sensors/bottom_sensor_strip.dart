import 'dart:async';

import 'package:flutter/material.dart';

import '../../../services/telemetry_service.dart';
import 'mpu_table.dart';
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
  Map<String, dynamic>? accelData;
  Map<String, dynamic>? gyroData;

  bool pirFront = false;
  bool pirBack = false;

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
    final pir = data['pir'];

    setState(() {
      accelData = mpu['accel'];
      gyroData = mpu['gyro'];
      pirFront = pir['front'];
      pirBack = pir['back'];
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (accelData == null || gyroData == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        SizedBox(
          width: 90,
          child: SensorTile(
            label: 'PIR 1',
            value: pirFront ? 'MOTION\n' : 'IDLE\n',
          ),
        ),

        const SizedBox(width: 8),

        SizedBox(
          width: 90,
          child: SensorTile(
            label: 'PIR 2',
            value: pirBack ? 'MOTION\n' : 'IDLE\n',
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          flex: 3,

          child: MpuTable(
            ax: accelData!['x'].toStringAsFixed(1),

            ay: accelData!['y'].toStringAsFixed(1),

            az: accelData!['z'].toStringAsFixed(1),

            gx: gyroData!['x'].toStringAsFixed(1),

            gy: gyroData!['y'].toStringAsFixed(1),

            gz: gyroData!['z'].toStringAsFixed(1),
          ),
        ),
      ],
    );
  }
}
