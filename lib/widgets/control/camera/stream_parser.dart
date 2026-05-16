import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Connects to an MJPEG stream and emits individual JPEG frames.
class MjpegStreamParser {
  final String url;

  StreamSubscription? _sub;

  MjpegStreamParser(this.url);

  /// Starts the stream. Calls [onFrame] for every complete JPEG found.
  Future<void> start(void Function(Uint8List frame) onFrame) async {
    final res = await http.Client().send(http.Request('GET', Uri.parse(url)));
    final buf = <int>[];

    _sub = res.stream.listen((chunk) {
      buf.addAll(chunk);

      while (true) {
        final s = _find(buf, [0xFF, 0xD8]);
        if (s == -1) break;

        final e = _find(buf, [0xFF, 0xD9], s + 2);
        if (e == -1) break;

        final img = Uint8List.fromList(buf.sublist(s, e + 2));
        buf.removeRange(0, e + 2);

        onFrame(img);
      }
    });
  }

  void cancel() => _sub?.cancel();

  int _find(List<int> d, List<int> seq, [int from = 0]) {
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
}
