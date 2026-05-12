import 'package:flutter/material.dart';
import 'package:delta_rover/widgets/add_dialog.dart';
import 'package:delta_rover/models/device.dart';
import 'package:delta_rover/widgets/device_tile.dart';
import '../services/device_storage_service.dart';
import 'control_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Device> devices = [];
  final storage = DeviceStorageService();

  @override
  void initState() {
    super.initState();
    loadDevices();
  }

  Future<void> loadDevices() async {
    final loadedDevices = await storage.loadDevices();

    setState(() {
      devices = loadedDevices;
    });
  }

  void addDevice(String name, String ip) {
    setState(() {
      devices.add(
        Device(
          name: name,
          ip: ip,
        ),
      );
    });

    storage.saveDevices(devices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '  Devices',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: devices.isEmpty
          ? const Center(
              child: Text("No devices added"),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];

                return DeviceTile(
                  device: device,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ControlScreen(),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddDeviceDialog(
              onAdd: addDevice,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
