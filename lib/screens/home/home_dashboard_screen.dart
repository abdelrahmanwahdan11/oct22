import 'package:flutter/material.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/widgets/device_tile.dart';
import 'package:smart_home_control/widgets/energy_capsule.dart';
import 'package:smart_home_control/widgets/filter_chips.dart';
import 'package:smart_home_control/widgets/room_mini_panel.dart';
import 'package:smart_home_control/widgets/top_greeting_bar.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final listenable = Listenable.merge([scope.devices, scope.rooms]);

    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final devices = scope.devices.devices.take(4).toList();
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopGreetingBar(),
                  const SizedBox(height: 16),
                  FilterChips(
                    items: const ['All', 'Living Room', 'Kitchen', 'Drawing'],
                    selected: scope.rooms.filter,
                    onSelected: (value) {
                      scope.rooms.setFilter(value);
                      scope.devices.setFilterRoom(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  const EnergyCapsule(
                    title: '1632kwh',
                    subtitle: 'Synced 3 hours ago',
                    trailing: '9% ↑',
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      RoomMiniPanel(
                        title: 'Drawing Room',
                        devicesSummary: '5/8',
                        temperature: '18°C',
                      ),
                      RoomMiniPanel(
                        title: 'Living Room',
                        devicesSummary: '6/12',
                        temperature: '28°C',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
