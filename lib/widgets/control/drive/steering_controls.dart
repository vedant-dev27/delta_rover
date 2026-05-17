import 'package:flutter/material.dart';
import 'package:delta_rover/services/motor_service.dart';
import 'drive_button.dart';

class SteeringControls extends StatelessWidget {
  const SteeringControls({super.key, required this.motorService});

  final MotorService motorService;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DriveButton(
          icon: Icons.keyboard_arrow_left,
          onPressed: motorService.left,
          onReleased: motorService.stop,
        ),
        const SizedBox(width: 24),
        DriveButton(
          icon: Icons.keyboard_arrow_right,
          onPressed: motorService.right,
          onReleased: motorService.stop,
        ),
      ],
    );
  }
}
