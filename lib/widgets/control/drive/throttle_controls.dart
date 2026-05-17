import 'package:flutter/material.dart';
import 'package:delta_rover/services/motor_service.dart';
import 'drive_button.dart';

class ThrottleControls extends StatelessWidget {
  const ThrottleControls({super.key, required this.motorService});

  final MotorService motorService;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DriveButton(
          icon: Icons.keyboard_arrow_up,
          onPressed: motorService.forward,
          onReleased: motorService.stop,
        ),
        const SizedBox(height: 24),
        DriveButton(
          icon: Icons.keyboard_arrow_down,
          onPressed: motorService.backward,
          onReleased: motorService.stop,
        ),
      ],
    );
  }
}
