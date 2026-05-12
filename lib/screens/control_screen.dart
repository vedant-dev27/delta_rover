import 'package:flutter/material.dart';
import 'package:delta_rover/widgets/control/camera/camera_view.dart';
import 'package:delta_rover/widgets/control/drive/drive_controls.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          CameraView(),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(36, 0, 0, 0),
                child: DriveControls(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
