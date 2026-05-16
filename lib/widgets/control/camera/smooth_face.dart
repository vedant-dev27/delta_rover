import 'package:flutter/widgets.dart';

class SmoothFace {
  final int id;

  Rect current;
  Rect _target;
  String label;

  static const double _speed = 3.0;

  SmoothFace(this.id, Rect initial, this.label)
      : current = initial,
        _target = initial;

  void setTarget(Rect target, String newLabel) {
    _target = target;
    label = newLabel;
  }

  void lerp(double dt) {
    final t = (_speed * dt).clamp(0.0, 1.0);
    current = Rect.lerp(current, _target, t)!;
  }
}
