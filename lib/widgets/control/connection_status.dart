import 'package:flutter/material.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({
    super.key,
    required this.connected,
  });

  final bool connected;

  @override
  Widget build(BuildContext context) {
    final color = connected ? Colors.greenAccent : Colors.redAccent;
    final text = connected ? 'CONNECTED' : 'DISCONNECTED';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B3B40), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
