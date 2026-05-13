import 'package:flutter/material.dart';

class DriveButton extends StatelessWidget {
  const DriveButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 68,
        height: 68,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              const Color(0xFF2A2A2E),
              const Color(0xFF161618),
            ],
          ),

          border: Border.all(
            color: const Color(0xFF3B3B40),
            width: 1.2,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Icon(
          icon,
          color: const Color(0xFFE6E6E6),
          size: 34,
        ),
      ),
    );
  }
}
