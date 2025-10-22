import 'package:flutter/material.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/device_template.dart';
import 'package:smart_home_control/widgets/device_tile.dart';
import 'package:smart_home_control/widgets/search_bar.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final loc = scope.auth.localization;
    final listenable = Listenable.merge([scope.devices, scope.rooms, scope.auth]);
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final devices = scope.devices.devices;
        return Scaffold(
          appBar: AppBar(
            title: Text(loc.t('devices')),
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
                          onPressed: () => _openCatalog(context, scope),
                          icon: const Icon(Icons.add),
                          label: Text(loc.t('add_device')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DeviceSearchBar(
                    hint: loc.t('search_device'),
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
                            children: [
                              Text(
                                loc.t('devices'),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                loc.t('energy_consumption'),
                                style: const TextStyle(color: Colors.white70),
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

  Future<void> _openCatalog(BuildContext context, ControllerScope scope) async {
    final templates = scope.devices.catalog;
    final rooms = scope.rooms.allRooms;
    final loc = scope.auth.localization;
    if (templates.isEmpty || rooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.t('add_device_catalog'))),
      );
      return;
    }

    DeviceTemplate? selectedTemplate = templates.first;
    String selectedRoom = rooms.first.id;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.t('catalog_header'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.t('catalog_subtitle'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DeviceTemplate>(
                    value: selectedTemplate,
                    decoration: InputDecoration(labelText: loc.t('add_device_catalog')),
                    items: templates
                        .map(
                          (template) => DropdownMenuItem(
                            value: template,
                            child: Text(template.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedTemplate = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedRoom,
                    decoration: InputDecoration(labelText: loc.t('select_room')),
                    items: rooms
                        .map(
                          (room) => DropdownMenuItem(
                            value: room.id,
                            child: Text(room.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedRoom = value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(loc.t('cancel')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(loc.t('save')),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    if (confirmed == true) {
      final room = rooms.firstWhere((room) => room.id == selectedRoom);
      final device = await scope.devices.addFromTemplate(
        selectedTemplate,
        selectedRoom,
        roomName: room.name,
      );
      if (!context.mounted) return;
      final message = loc.t('device_added').replaceAll('{name}', device.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
