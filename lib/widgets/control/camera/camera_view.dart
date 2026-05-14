import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class CameraView extends StatelessWidget {
  const CameraView({
    super.key,
    required this.ip,
  });

  final String ip;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,

      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF3B3B40),
            width: 1.2,
          ),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),

          child: Transform.rotate(
            angle: 3.1415926535,
            child: Mjpeg(
              stream: 'http://$ip:8000/stream',
              isLive: true,
              fit: BoxFit.cover,

              error: (context, error, stack) {
                return const Center(
                  child: Text(
                    'Camera Offline',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
