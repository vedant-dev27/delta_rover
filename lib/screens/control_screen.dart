import 'package:delta_rover/widgets/control/drive/steering_controls.dart';
import 'package:delta_rover/widgets/control/drive/throttle_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:delta_rover/widgets/control/camera/camera_view.dart';
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0D13),

      body: SafeArea(
        child: Row(
          children: [
            // LEFT PANEL
            Container(
              width: 220,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SensorPanel(),

                  const Spacer(),

                  const ThrottleControls(),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // CENTER CAMERA
            const Expanded(
              child: CameraView(),
            ),

            // RIGHT PANEL
            Container(
              width: 220,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Spacer(),

                  const SteeringControls(),

                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
