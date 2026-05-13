import 'package:flutter/material.dart';

import 'drive_button.dart';

class ThrottleControls extends StatelessWidget {
  const ThrottleControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DriveButton(
          icon: Icons.keyboard_arrow_up,
          onTap: () {},
        ),

        const SizedBox(height: 24),

        DriveButton(
          icon: Icons.keyboard_arrow_down,
          onTap: () {},
        ),
      ],
    );
  }
}
