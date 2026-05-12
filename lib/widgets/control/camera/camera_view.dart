import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Camera Feed Placeholder',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
