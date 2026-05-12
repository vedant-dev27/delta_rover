import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/device.dart';

class DeviceStorageService {
  static const devicesKey = 'devices';

  Future<void> saveDevices(List<Device> devices) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = devices.map((device) {
      return jsonEncode(device.toJson());
    }).toList();

    await prefs.setStringList(
      devicesKey,
      jsonList,
    );
  }

  Future<List<Device>> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = prefs.getStringList(devicesKey);

    if (jsonList == null) {
      return [];
    }

    return jsonList.map((item) {
      return Device.fromJson(
        jsonDecode(item),
      );
    }).toList();
  }
}
