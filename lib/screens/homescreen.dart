import 'package:flutter/material.dart';
import 'package:delta_rover/widgets/add_dialog.dart';
import 'package:delta_rover/models/device.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Device> devices = [];

  void addDevice(String name, String ip) {
    setState(() {
      devices.add(
        Device(name: name, ip: ip),
      );
    });
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

                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.ip),
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
