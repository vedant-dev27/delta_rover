import 'package:delta_rover/widgets/control/connection_status.dart';
import 'package:delta_rover/widgets/control/drive/steering_controls.dart';
import 'package:delta_rover/widgets/control/drive/throttle_controls.dart';
import 'package:delta_rover/widgets/control/servo/servo_sliders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:delta_rover/widgets/control/camera/camera_view.dart';
import 'package:delta_rover/widgets/control/sensors/top_sensor_strip.dart';
import 'package:delta_rover/widgets/control/sensors/bottom_sensor_strip.dart';

const _kPanelColor = Color(0xFF1C1C1F);
const _kPanelBorder = Color(0xFF3B3B40);
const _kPanelRadius = 16.0;

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0D13),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // LEFT PANEL
              _Panel(
                width: 200,
                child: Column(
                  children: [
                    ConnectionStatus(connected: true),
                    const Spacer(),
                    const ThrottleControls(),
                    const SizedBox(height: 48),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // CENTER
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: CameraView()),
                    const SizedBox(height: 10),
                    const TopSensorStrip(),
                    const SizedBox(height: 10),
                    const BottomSensorStrip(),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // RIGHT PANEL
              _Panel(
                width: 200,
                child: Column(
                  children: const [
                    ServoSliders(),
                    Spacer(),
                    SteeringControls(),
                    SizedBox(height: 78),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final double width;
  final Widget child;

  const _Panel({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kPanelColor,
        borderRadius: BorderRadius.circular(_kPanelRadius),
        border: Border.all(
          color: _kPanelBorder,
          width: 1.2,
        ),
      ),
      child: child,
    );
  }
}
