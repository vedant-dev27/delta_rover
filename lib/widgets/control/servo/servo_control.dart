import 'package:flutter/material.dart';

import 'servo_button.dart';

class ServoControls extends StatelessWidget {
  const ServoControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ServoButton(
          icon: Icons.keyboard_arrow_up,
          onTap: () {
            // look up later
          },
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ServoButton(
              icon: Icons.keyboard_arrow_left,
              onTap: () {
                // look left later
              },
            ),

            const SizedBox(width: 8),

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 8),

            ServoButton(
              icon: Icons.keyboard_arrow_right,
              onTap: () {
                // look right later
              },
            ),
          ],
        ),

        const SizedBox(height: 8),

        ServoButton(
          icon: Icons.keyboard_arrow_down,
          onTap: () {
            // look down later
          },
        ),
      ],
    );
  }
}
