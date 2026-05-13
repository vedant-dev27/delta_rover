import 'package:flutter/material.dart';

class DriveButton extends StatefulWidget {
  const DriveButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<DriveButton> createState() => _DriveButtonState();
}

class _DriveButtonState extends State<DriveButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _pressed
                ? [const Color(0xFF1A1A1E), const Color(0xFF0E0E10)]
                : [const Color(0xFF2A2A2E), const Color(0xFF161618)],
          ),
          border: Border.all(
            color: _pressed ? const Color(0xFFFFB000) : const Color(0xFF3B3B40),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _pressed ? 0.15 : 0.35),
              blurRadius: _pressed ? 4 : 10,
              offset: Offset(0, _pressed ? 1 : 4),
            ),
          ],
        ),
        child: Icon(
          widget.icon,
          color: _pressed ? const Color(0xFFFFB000) : const Color(0xFFE6E6E6),
          size: 34,
        ),
      ),
    );
  }
}
