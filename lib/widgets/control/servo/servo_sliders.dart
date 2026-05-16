import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServoSliders extends StatefulWidget {
  const ServoSliders({
    super.key,
    required this.ip,
  });

  final String ip;

  @override
  State<ServoSliders> createState() => _ServoSlidersState();
}

class _ServoSlidersState extends State<ServoSliders> {
  double horizontal = 0;
  double vertical = 0;

  Timer? _debounce;

  Future<void> _postVelocity(String axis, double velocity) async {
    final uri = Uri.parse('http://${widget.ip}:8000/servo/$axis');
    try {
      await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'velocity': velocity}),
      );
    } catch (e) {
      debugPrint('Failed to POST /servo/$axis: $e');
    }
  }

  void _onHorizontalChanged(double value) {
    setState(() => horizontal = value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 30), () {
      _postVelocity('x', value);
    });
  }

  void _onVerticalChanged(double value) {
    setState(() => vertical = value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 30), () {
      _postVelocity('y', value);
    });
  }

  void _onHorizontalChangeEnd(double _) {
    setState(() => horizontal = 0);
    _debounce?.cancel();
    _postVelocity('x', 0);
  }

  void _onVerticalChangeEnd(double _) {
    setState(() => vertical = 0);
    _debounce?.cancel();
    _postVelocity('y', 0);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFFB000);

    SliderThemeData sliderTheme(BuildContext ctx) =>
        SliderTheme.of(ctx).copyWith(
          activeTrackColor: accent,
          inactiveTrackColor: Colors.grey.shade800,
          thumbColor: accent,
          overlayColor: accent.withValues(alpha: 0.2),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CAMERA PAN',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        SliderTheme(
          data: sliderTheme(context),
          child: Slider(
            value: horizontal,
            min: -1,
            max: 1,
            onChanged: _onHorizontalChanged,
            onChangeEnd: _onHorizontalChangeEnd,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'CAMERA TILT',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        SliderTheme(
          data: sliderTheme(context),
          child: Slider(
            value: vertical,
            min: -1,
            max: 1,
            onChanged: _onVerticalChanged,
            onChangeEnd: _onVerticalChangeEnd,
          ),
        ),
      ],
    );
  }
}
