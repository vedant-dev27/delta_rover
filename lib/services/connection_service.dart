import 'dart:io';

class ConnectionService {
  Future<bool> connect(String ip) async {
    try {
      final request = await HttpClient().getUrl(
        Uri.parse('http://$ip:8000/stream'),
      );

      final response = await request.close();

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
