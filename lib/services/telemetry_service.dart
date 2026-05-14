import 'dart:convert';

import 'package:http/http.dart' as http;

class TelemetryService {
  static Future<Map<String, dynamic>?> getData(
    String ip,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://$ip:8000/telemetry',
        ),
      );

      return jsonDecode(response.body);
    } catch (_) {
      return null;
    }
  }
}
