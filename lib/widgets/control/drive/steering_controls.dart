import 'package:flutter/material.dart';

import 'drive_button.dart';

class SteeringControls extends StatelessWidget {
  const SteeringControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DriveButton(
          icon: Icons.keyboard_arrow_left,
          onTap: () {},
        ),

        const SizedBox(width: 24),

        DriveButton(
          icon: Icons.keyboard_arrow_right,
          onTap: () {},
        ),
      ],
    );
  }
}
