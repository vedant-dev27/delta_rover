import 'package:flutter/material.dart';
import 'package:delta_rover/widgets/control/camera/camera_view.dart';
import 'package:delta_rover/widgets/control/drive/drive_controls.dart';
import 'package:delta_rover/widgets/control/servo/servo_control.dart';
import 'package:delta_rover/widgets/control/sensors/sensor_panel.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          CameraView(),

          Padding(
            padding: EdgeInsets.all(16),
            child: SensorPanel(),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DriveControls(),
                  ServoControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
