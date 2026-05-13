import 'package:flutter/material.dart';
import 'package:delta_rover/models/device.dart';
import 'package:delta_rover/services/connection_service.dart';
import 'package:delta_rover/services/device_storage_service.dart';
import 'package:delta_rover/screens/control_screen.dart';
import 'package:delta_rover/widgets/device/device_tile.dart';
import 'package:delta_rover/widgets/device/add_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Device> devices = [];
  final storage = DeviceStorageService();
  final connectionService = ConnectionService();

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
                  onTap: () async {
                    final success = await connectionService.connect(device.ip);

                    if (!context.mounted) return;

                    if (success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ControlScreen(
                            ip: device.ip,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to connect'),
                        ),
                      );
                    }
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
