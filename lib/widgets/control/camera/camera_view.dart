import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';

import 'face_box.dart';
import 'face_recognizer.dart';
import 'smooth_face.dart';
import 'stable_label.dart';
import 'stream_parser.dart';

class CameraView extends StatefulWidget {
  final String ip;
  const CameraView({super.key, required this.ip});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────

  Uint8List? _frame;
  Size _imageSize = const Size(320, 240);
  List<SmoothFace> _faces = [];

  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  final FaceRecognizer _recognizer = FaceRecognizer();
  FaceDetector? _detector;
  MjpegStreamParser? _parser;

  bool _ready = false;
  bool _busy = false;

  final Map<int, StableLabel> _stable = {};

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    _init();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _parser?.cancel();
    _detector?.close();
    _recognizer.close();
    super.dispose();
  }

  // ── Init ───────────────────────────────────────────────────────────────────

  Future<void> _init() async {
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableTracking: true,
      ),
    );

    await _recognizer.init();

    _ready = true;

    _parser = MjpegStreamParser('http://${widget.ip}:8000/stream');
    await _parser!.start(_onFrame);
  }

  // ── Ticker ─────────────────────────────────────────────────────────────────

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMilliseconds / 1000.0;
    _lastTick = elapsed;

    for (final f in _faces) {
      f.lerp(dt);
    }

    if (mounted) setState(() {}); // ← remove the _faces.isNotEmpty guard
  }

  // ── Frame pipeline ─────────────────────────────────────────────────────────

  void _onFrame(Uint8List bytes) {
    _frame = bytes;
    if (!_ready || _busy) return;
    _run(bytes);
  }

  Future<void> _run(Uint8List bytes) async {
    _busy = true;

    try {
      // ── 1. Detect faces ────────────────────────────────────────────────────
      final tmp = File('${(await getTemporaryDirectory()).path}/f.jpg');
      await tmp.writeAsBytes(bytes);

      final detected = await _detector!.processImage(
        InputImage.fromFilePath(tmp.path),
      );

      if (detected.isEmpty) {
        _faces = [];
        _stable.clear();
        return;
      }

      // ── 2. Decode full image ───────────────────────────────────────────────
      final codec = await ui.instantiateImageCodec(bytes);
      final img = (await codec.getNextFrame()).image;

      final w = img.width.toDouble();
      final h = img.height.toDouble();
      _imageSize = Size(w, h);

      // ── 3. Recognise each face ─────────────────────────────────────────────
      final seen = <int>{};
      final updated = <SmoothFace>[..._faces];

      for (final face in detected) {
        final b = face.boundingBox;

        final left = b.left.clamp(0.0, w - 1);
        final top = b.top.clamp(0.0, h - 1);
        final right = b.right.clamp(0.0, w);
        final bottom = b.bottom.clamp(0.0, h);

        // Crop face to 112×112
        final rec = ui.PictureRecorder();
        final canvas = ui.Canvas(rec);
        canvas.drawImageRect(
          img,
          Rect.fromLTRB(left, top, right, bottom),
          const Rect.fromLTWH(0, 0, 112, 112),
          Paint(),
        );

        final crop = await rec.endRecording().toImage(112, 112);
        final bd = await crop.toByteData(format: ui.ImageByteFormat.rawRgba);
        if (bd == null) continue;

        // ── 4. Identify ────────────────────────────────────────────────────
        final name = _recognizer.identify(bd.buffer.asUint8List());

        final id = face.trackingId ?? 0;
        seen.add(id);

        _stable.putIfAbsent(id, StableLabel.new).vote(name);
        final stableName = _stable[id]!.label;

        final rect = Rect.fromLTRB(left, top, right, bottom);
        final existing = updated.where((f) => f.id == id).firstOrNull;

        if (existing != null) {
          existing.setTarget(rect, stableName);
        } else {
          updated.add(SmoothFace(id, rect, stableName));
        }
      }

      _stable.removeWhere((k, _) => !seen.contains(k));
      _faces = updated.where((f) => seen.contains(f.id)).toList();
    } finally {
      _busy = false;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

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
          child: _frame == null
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final imgAspect = _imageSize.width / _imageSize.height;
                    final boxAspect =
                        constraints.maxWidth / constraints.maxHeight;

                    double renderW, renderH, offsetX, offsetY;

                    if (imgAspect > boxAspect) {
                      renderW = constraints.maxWidth;
                      renderH = renderW / imgAspect;
                      offsetX = 0;
                      offsetY = (constraints.maxHeight - renderH) / 2;
                    } else {
                      renderH = constraints.maxHeight;
                      renderW = renderH * imgAspect;
                      offsetX = (constraints.maxWidth - renderW) / 2;
                      offsetY = 0;
                    }

                    final scaleX = renderW / _imageSize.width;
                    final scaleY = renderH / _imageSize.height;

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // Video frame
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

                        // Face overlays
                        IgnorePointer(
                          child: Stack(
                            children: _faces.map((f) {
                              final r = f.current;
                              final isKnown = !f.label.startsWith('Unknown');
                              return Positioned(
                                left: offsetX + r.left * scaleX,
                                top: offsetY + r.top * scaleY,
                                width: r.width * scaleX,
                                height: r.height * scaleY,
                                child: FaceBox(
                                  label: f.label,
                                  color: isKnown
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                ),
                              );
                            }).toList(),
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
