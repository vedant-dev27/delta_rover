import 'dart:async';

import 'package:flutter/material.dart';

import '../../../services/sensors/dht_service.dart';
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
    final data = await DhtService.getData(
      widget.ip,
    );

    if (data == null || !mounted) return;

    setState(() {
      if (data['temperature'] != null) {
        temperature = '${data['temperature']}';
      }

      if (data['humidity'] != null) {
        humidity = '${data['humidity']}';
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
