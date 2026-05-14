import 'dart:async';

import 'package:flutter/material.dart';

import '../../../services/telemetry_service.dart';
import 'sensor_tile.dart';

class TopSensorStrip extends StatefulWidget {
  const TopSensorStrip({
    super.key,
    required this.ip,
  });

  final String ip;

  @override
  State<TopSensorStrip> createState() => _TopSensorStripState();
}

class _TopSensorStripState extends State<TopSensorStrip> {
  String temperature = '--';
  String humidity = '--';

  Timer? timer;

  @override
  void initState() {
    super.initState();

    fetch();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => fetch(),
    );
  }

  Future<void> fetch() async {
    final data = await TelemetryService.getData(
      widget.ip,
    );

    if (data == null || !mounted) return;

    setState(() {
      final dht = data['dht'];

      if (dht['temperature'] != null) {
        temperature = '${dht['temperature']}';
      }

      if (dht['humidity'] != null) {
        humidity = '${dht['humidity']}';
      }
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
            label: 'U1',
            value: '--',
          ),
        ),

        const SizedBox(width: 8),

        const Expanded(
          child: SensorTile(
            label: 'U2',
            value: '--',
          ),
        ),

        const SizedBox(width: 8),

        const Expanded(
          child: SensorTile(
            label: 'U3',
            value: '--',
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'TEMP',
            value: temperature,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: SensorTile(
            label: 'HUM',
            value: humidity,
          ),
        ),
      ],
    );
  }
}
