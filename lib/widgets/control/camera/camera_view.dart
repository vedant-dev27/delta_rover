import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    required this.ip,
  });

  final String ip;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>
    with SingleTickerProviderStateMixin {
  Uint8List? _frame;

  Size _imageSize = const Size(320, 240);

  List<_SmoothFace> _faces = [];

  late final Ticker _ticker;

  Duration _lastTick = Duration.zero;

  FaceDetector? _detector;

  Interpreter? _interpreter;

  Map<String, List<List<double>>> _db = {};

  bool _ready = false;

  bool _busy = false;

  StreamSubscription? _sub;

  final Map<int, _StableLabel> _stable = {};

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onTick)..start();

    _init();
  }

  void _onTick(
    Duration elapsed,
  ) {
    final dt = (elapsed - _lastTick).inMilliseconds / 1000.0;

    _lastTick = elapsed;

    for (final f in _faces) {
      f.lerp(dt);
    }

    if (mounted && _faces.isNotEmpty) {
      setState(() {});
    }
  }

  Future<void> _init() async {
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableTracking: true,
      ),
    );

    _interpreter = await Interpreter.fromAsset(
      'assets/model.tflite',
    );

    final raw = json.decode(
      await rootBundle.loadString(
        'assets/db.json',
      ),
    );

    _db = (raw as Map<String, dynamic>).map((k, v) {
      final list = (v as List).map((e) {
        final emb = (e as List)
            .map(
              (x) => (x as num).toDouble(),
            )
            .toList();

        return _normalize(emb);
      }).toList();

      return MapEntry(k, list);
    });

    _ready = true;

    _startStream();
  }

  void _startStream() {
    http.Client()
        .send(
          http.Request(
            'GET',
            Uri.parse(
              'http://${widget.ip}:8000/stream',
            ),
          ),
        )
        .then((res) {
          final buf = <int>[];

          _sub = res.stream.listen(
            (chunk) {
              buf.addAll(chunk);

              while (true) {
                final s = _find(
                  buf,
                  [0xFF, 0xD8],
                );

                if (s == -1) break;

                final e = _find(
                  buf,
                  [0xFF, 0xD9],
                  s + 2,
                );

                if (e == -1) break;

                final img = Uint8List.fromList(
                  buf.sublist(
                    s,
                    e + 2,
                  ),
                );

                buf.removeRange(
                  0,
                  e + 2,
                );

                _onFrame(img);
              }
            },
          );
        });
  }

  int _find(
    List<int> d,
    List<int> seq, [
    int from = 0,
  ]) {
    for (int i = from; i <= d.length - seq.length; i++) {
      bool ok = true;

      for (int j = 0; j < seq.length; j++) {
        if (d[i + j] != seq[j]) {
          ok = false;
          break;
        }
      }

      if (ok) return i;
    }

    return -1;
  }

  void _onFrame(
    Uint8List bytes,
  ) {
    _frame = bytes;

    if (!_ready || _busy || _interpreter == null) {
      return;
    }

    _run(bytes);
  }

  Future<void> _run(
    Uint8List bytes,
  ) async {
    _busy = true;

    try {
      final tmp = File(
        '${(await getTemporaryDirectory()).path}/f.jpg',
      );

      await tmp.writeAsBytes(
        bytes,
      );

      final detected = await _detector!.processImage(
        InputImage.fromFilePath(
          tmp.path,
        ),
      );

      if (detected.isEmpty) {
        _faces = [];

        _stable.clear();

        return;
      }

      final codec = await ui.instantiateImageCodec(
        bytes,
      );

      final img = (await codec.getNextFrame()).image;

      final w = img.width.toDouble();

      final h = img.height.toDouble();

      _imageSize = Size(w, h);

      final dim = _interpreter!.getOutputTensor(0).shape[1];

      final seen = <int>{};

      final updated = <_SmoothFace>[
        ..._faces,
      ];

      for (final face in detected) {
        final b = face.boundingBox;

        final left = b.left.clamp(
          0.0,
          w - 1,
        );

        final top = b.top.clamp(
          0.0,
          h - 1,
        );

        final right = b.right.clamp(
          0.0,
          w,
        );

        final bottom = b.bottom.clamp(
          0.0,
          h,
        );

        final rec = ui.PictureRecorder();

        final canvas = ui.Canvas(rec);

        canvas.drawImageRect(
          img,
          Rect.fromLTRB(
            left,
            top,
            right,
            bottom,
          ),
          const Rect.fromLTWH(
            0,
            0,
            112,
            112,
          ),
          Paint(),
        );

        final crop = await rec.endRecording().toImage(
          112,
          112,
        );

        final bd = await crop.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );

        if (bd == null) {
          continue;
        }

        final rgba = bd.buffer.asUint8List();

        final input = List.generate(
          1,
          (_) => List.generate(
            112,
            (y) => List.generate(
              112,
              (x) {
                final i = (y * 112 + x) * 4;

                return [
                  (rgba[i] / 127.5) - 1.0,
                  (rgba[i + 1] / 127.5) - 1.0,
                  (rgba[i + 2] / 127.5) - 1.0,
                ];
              },
            ),
          ),
        );

        final output =
            List.filled(
              dim,
              0.0,
            ).reshape([
              1,
              dim,
            ]);

        _interpreter!.run(
          input,
          output,
        );

        final emb = _normalize(
          List<double>.from(
            output[0],
          ),
        );

        String name = 'Unknown';

        double best = 0;

        for (final entry in _db.entries) {
          for (final d in entry.value) {
            final sim = _cosine(
              emb,
              d,
            );

            if (sim > best) {
              best = sim;
              name = entry.key;
            }
          }
        }

        if (best < 0.30) {
          name = 'Unknown';
        }

        final id = face.trackingId ?? 0;

        seen.add(id);

        _stable
            .putIfAbsent(
              id,
              () => _StableLabel(),
            )
            .vote(name);

        final stableName = _stable[id]!.label;

        final label = stableName;

        final rect = Rect.fromLTRB(
          left,
          top,
          right,
          bottom,
        );

        final existing = updated
            .where(
              (f) => f.id == id,
            )
            .firstOrNull;

        if (existing != null) {
          existing.setTarget(
            rect,
            label,
          );
        } else {
          updated.add(
            _SmoothFace(
              id,
              rect,
              label,
            ),
          );
        }
      }

      _stable.removeWhere(
        (k, _) => !seen.contains(k),
      );

      _faces = updated
          .where(
            (f) => seen.contains(
              f.id,
            ),
          )
          .toList();
    } finally {
      _busy = false;
    }
  }

  List<double> _normalize(
    List<double> v,
  ) {
    double n = sqrt(
      v.fold(
        0,
        (s, e) => s + e * e,
      ),
    );

    return n == 0
        ? v
        : v
              .map(
                (e) => e / n,
              )
              .toList();
  }

  double _cosine(
    List<double> a,
    List<double> b,
  ) {
    double d = 0;
    double na = 0;
    double nb = 0;

    for (int i = 0; i < a.length; i++) {
      d += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }

    return d / (sqrt(na) * sqrt(nb));
  }

  @override
  void dispose() {
    _ticker.dispose();
    _sub?.cancel();
    _detector?.close();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AspectRatio(
      aspectRatio: 3 / 2,

      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(
            12,
          ),
          border: Border.all(
            color: const Color(
              0xFF3B3B40,
            ),
            width: 1.2,
          ),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            12,
          ),

          child: _frame == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : LayoutBuilder(
                  builder:
                      (
                        context,
                        constraints,
                      ) {
                        final imgAspect = _imageSize.width / _imageSize.height;

                        final boxAspect =
                            constraints.maxWidth / constraints.maxHeight;

                        double renderW;
                        double renderH;
                        double offsetX;
                        double offsetY;

                        if (imgAspect > boxAspect) {
                          renderW = constraints.maxWidth;

                          renderH = renderW / imgAspect;

                          offsetX = 0;

                          offsetY = (constraints.maxHeight - renderH) / 2;
                        } else {
                          renderH = constraints.maxHeight;

                          renderW = renderH * imgAspect;

                          renderW = renderH * imgAspect;

                          offsetX = (constraints.maxWidth - renderW) / 2;

                          offsetY = 0;
                        }

                        final scaleX = renderW / _imageSize.width;

                        final scaleY = renderH / _imageSize.height;

                        return Stack(
                          fit: StackFit.expand,

                          children: [
                            // VIDEO
                            Positioned(
                              left: offsetX,
                              top: offsetY,
                              width: renderW,
                              height: renderH,

                              child: RepaintBoundary(
                                child: Image.memory(
                                  _frame!,

                                  fit: BoxFit.fill,

                                  gaplessPlayback: true,

                                  filterQuality: FilterQuality.low,
                                ),
                              ),
                            ),

                            // FACE BOXES
                            IgnorePointer(
                              child: Stack(
                                children: _faces.map(
                                  (f) {
                                    final r = f.current;

                                    final isKnown = !f.label.startsWith(
                                      'Unknown',
                                    );
                                    return Positioned(
                                      left: offsetX + (r.left * scaleX),

                                      top: offsetY + (r.top * scaleY),

                                      width: r.width * scaleX,

                                      height: r.height * scaleY,

                                      child: _FaceBox(
                                        label: f.label,

                                        color: isKnown
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                ),
        ),
      ),
    );
  }
}

class _FaceBox extends StatelessWidget {
  const _FaceBox({
    required this.label,
    required this.color,
  });

  final String label;

  final Color color;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      alignment: Alignment.topLeft,
      child: Container(
        color: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _SmoothFace {
  final int id;

  Rect current;

  Rect _target;

  String label;

  static const double _speed = 3.0;

  _SmoothFace(
    this.id,
    Rect initial,
    this.label,
  ) : current = initial,
      _target = initial;

  void setTarget(
    Rect target,
    String newLabel,
  ) {
    _target = target;
    label = newLabel;
  }

  bool lerp(double dt) {
    final t = (_speed * dt).clamp(
      0.0,
      1.0,
    );

    current = Rect.lerp(
      current,
      _target,
      t,
    )!;

    return true;
  }
}

class _StableLabel {
  String label = 'Unknown';

  final List<String> _history = [];

  static const int _window = 6;

  void vote(String name) {
    _history.add(name);

    if (_history.length > _window) {
      _history.removeAt(0);
    }

    final counts = <String, int>{};

    for (final n in _history) {
      counts[n] = (counts[n] ?? 0) + 1;
    }

    label = counts.entries
        .reduce(
          (a, b) => a.value >= b.value ? a : b,
        )
        .key;
  }
}
