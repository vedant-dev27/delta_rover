import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Loads the TFLite model and embedding database, then identifies faces.
class FaceRecognizer {
  Interpreter? _interpreter;
  Map<String, List<List<double>>> _db = {};

  static const double _threshold = 0.40;

  Future<void> init() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');

    final raw = json.decode(await rootBundle.loadString('assets/db.json'));
    _db = (raw as Map<String, dynamic>).map((k, v) {
      final embeddings = (v as List).map((e) {
        final emb = (e as List).map((x) => (x as num).toDouble()).toList();
        return _normalize(emb);
      }).toList();
      return MapEntry(k, embeddings);
    });
  }

  /// Returns the name (or 'Unknown') for the given 112×112 RGBA pixel buffer.
  ///
  /// [rgba] must be exactly 112 * 112 * 4 bytes.
  String identify(Uint8List rgba) {
    assert(_interpreter != null, 'Call init() before identify()');

    final dim = _interpreter!.getOutputTensor(0).shape[1];

    final input = List.generate(
      1,
      (_) => List.generate(
        112,
        (y) => List.generate(112, (x) {
          final i = (y * 112 + x) * 4;
          return [
            (rgba[i] / 127.5) - 1.0,
            (rgba[i + 1] / 127.5) - 1.0,
            (rgba[i + 2] / 127.5) - 1.0,
          ];
        }),
      ),
    );

    final output = List.filled(dim, 0.0).reshape([1, dim]);
    _interpreter!.run(input, output);

    final emb = _normalize(List<double>.from(output[0]));

    String name = 'Unknown';
    double best = 0;

    for (final entry in _db.entries) {
      for (final d in entry.value) {
        final sim = _cosine(emb, d);
        if (sim > best) {
          best = sim;
          name = entry.key;
        }
      }
    }

    return best < _threshold ? 'Unknown' : name;
  }

  void close() => _interpreter?.close();

  // ── Math helpers ──────────────────────────────────────────────────────────

  List<double> _normalize(List<double> v) {
    final n = sqrt(v.fold(0.0, (s, e) => s + e * e));
    return n == 0 ? v : v.map((e) => e / n).toList();
  }

  double _cosine(List<double> a, List<double> b) {
    double d = 0, na = 0, nb = 0;
    for (int i = 0; i < a.length; i++) {
      d += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }
    return d / (sqrt(na) * sqrt(nb));
  }
}
