import 'package:flutter/material.dart';
import 'package:delta_rover/widgets/control/camera/camera_view.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          CameraView(),
          Expanded(
            child: Center(
              child: Text(
                "Robot Controls Here",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
