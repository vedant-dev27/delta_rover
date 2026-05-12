import 'package:flutter/material.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control"),
      ),
      body: const Center(
        child: Text(
          "Robot Controls Here",
        ),
      ),
    );
  }
}
