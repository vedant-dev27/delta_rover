import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:delta_rover/widgets/control/camera/camera_view.dart';
import 'package:delta_rover/widgets/control/drive/drive_controls.dart';
import 'package:delta_rover/widgets/control/servo/servo_control.dart';
import 'package:delta_rover/widgets/control/sensors/sensor_panel.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          CameraView(),

          Padding(
            padding: EdgeInsets.all(12),
            child: SensorPanel(),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
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
