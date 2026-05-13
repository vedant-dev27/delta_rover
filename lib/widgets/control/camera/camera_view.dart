import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B3B40), width: 1.2),
      ),
      child: const Center(
        child: Text(
          'Camera Feed Placeholder',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      ),
    );
  }
}
