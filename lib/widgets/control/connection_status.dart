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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 8),

        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
