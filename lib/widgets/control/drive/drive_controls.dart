import 'package:flutter/material.dart';

import 'drive_button.dart';

class DriveControls extends StatelessWidget {
  const DriveControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 56,
          height: 56,
        ),

        const SizedBox(height: 8),

        DriveButton(
          icon: Icons.keyboard_arrow_up,
          onTap: () {},
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DriveButton(
              icon: Icons.keyboard_arrow_left,
              onTap: () {},
            ),

            const SizedBox(width: 8),

            const SizedBox(
              width: 56,
              height: 56,
            ),

            const SizedBox(width: 8),

            DriveButton(
              icon: Icons.keyboard_arrow_right,
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 8),

        DriveButton(
          icon: Icons.keyboard_arrow_down,
          onTap: () {},
        ),
      ],
    );
  }
}
