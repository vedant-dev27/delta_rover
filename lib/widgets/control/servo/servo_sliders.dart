import 'package:flutter/material.dart';

class ServoSliders extends StatefulWidget {
  const ServoSliders({super.key});

  @override
  State<ServoSliders> createState() => _ServoSlidersState();
}

class _ServoSlidersState extends State<ServoSliders> {
  double horizontal = 0;
  double vertical = 0;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFFB000);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CAMERA PAN',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accent,
            inactiveTrackColor: Colors.grey.shade800,
            thumbColor: accent,
            overlayColor: accent.withValues(alpha: 0.2),
          ),

          child: Slider(
            value: horizontal,
            min: -1,
            max: 1,
            onChanged: (value) {
              setState(() {
                horizontal = value;
              });
            },
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'CAMERA TILT',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accent,
            inactiveTrackColor: Colors.grey.shade800,
            thumbColor: accent,
            overlayColor: accent.withValues(alpha: 0.2),
          ),

          child: Slider(
            value: vertical,
            min: -1,
            max: 1,
            onChanged: (value) {
              setState(() {
                vertical = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
