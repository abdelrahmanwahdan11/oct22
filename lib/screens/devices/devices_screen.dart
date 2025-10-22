import 'package:flutter/material.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/widgets/device_tile.dart';
import 'package:smart_home_control/widgets/search_bar.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    return AnimatedBuilder(
      animation: scope.devices,
      builder: (context, _) {
        final devices = scope.devices.devices;
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Device'),
            actions: [
              IconButton(
                icon: const Icon(Icons.view_module_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text('Add Device'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DeviceSearchBar(
                    hint: 'Search Device',
                    onChanged: scope.devices.setSearch,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF2EA6FF), Color(0xFF117BDB)]),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.devices_outlined, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Total 25 Devices',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Connect & Manage Devices',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      itemCount: devices.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return DeviceTile(
                          device: device,
                          onTap: () => _openDevice(context, device),
                          onToggle: (value) => scope.devices.toggleDevice(device.id, value),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openDevice(BuildContext context, Device device) {
    Navigator.of(context).pushNamed(device.type.route, arguments: device.id);
  }
}
