import 'package:http/http.dart' as http;

class MotorService {
  MotorService({required this.ip});

  final String ip;

  String get _base => 'http://$ip:8000/motors';

  Future<void> _post(String action) async {
    try {
      await http.post(Uri.parse('$_base/$action'));
    } catch (e) {
      // silently ignore — rover may be momentarily unreachable
    }
  }

  Future<void> forward() => _post('forward');
  Future<void> backward() => _post('backward');
  Future<void> left() => _post('left');
  Future<void> right() => _post('right');
  Future<void> stop() => _post('stop');
}
