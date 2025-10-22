import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/devices_controller.dart';
import 'package:smart_home_control/core/app_router.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/core/feature_catalog.dart';
import 'package:smart_home_control/core/responsive.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/energy_point.dart';
import 'package:smart_home_control/widgets/device_tile.dart';
import 'package:smart_home_control/widgets/energy_capsule.dart';
import 'package:smart_home_control/widgets/filter_chips.dart';
import 'package:smart_home_control/widgets/feature_highlights.dart';
import 'package:smart_home_control/widgets/room_mini_panel.dart';
import 'package:smart_home_control/widgets/top_greeting_bar.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final listenable = Listenable.merge([
      scope.devices,
      scope.rooms,
      scope.settings,
      scope.energy,
      scope.auth,
    ]);

    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final devicesController = scope.devices;
        final roomsController = scope.rooms;
        final settings = scope.settings;
        final energy = scope.energy;
        final loc = scope.auth.localization;
        final featuredDevices = devicesController.devices.take(4).toList();
        final rooms = roomsController.rooms.take(2).toList();
        final activeEnhancements = enhancementCatalog
            .where((option) => settings.isEnhancementEnabled(option.id))
            .take(8)
            .toList();
        final budgetGuard = settings.isEnhancementEnabled('energy_budget_guard');
        final showEnergy = settings.isEnhancementEnabled('energy_saver') || budgetGuard;
        final showBattery = settings.isEnhancementEnabled('battery_watch');
        final showHealth = settings.isEnhancementEnabled('device_health');
        final quickScenes = [
          _SceneAction(id: 'movie', icon: Icons.theaters_outlined, label: loc.t('scene_movie')),
          _SceneAction(id: 'away', icon: Icons.flight_takeoff, label: loc.t('scene_away')),
          _SceneAction(id: 'wake', icon: Icons.wb_sunny_outlined, label: loc.t('scene_wake')),
          _SceneAction(id: 'clean', icon: Icons.cleaning_services, label: loc.t('scene_clean')),
        ];
        final highlightPoint = energy.points
            .firstWhere(
              (point) => point.month == energy.highlight,
              orElse: () => energy.points.isNotEmpty
                  ? energy.points.first
                  : const EnergyPoint(month: 'Now', kwh: 0),
            );
        final totalKwh = energy.points.fold<int>(0, (sum, point) => sum + point.kwh);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: ResponsiveConstrainedBox(
              builder: (context, constraints) {
                final padding = AppBreakpoints.geometry(constraints.maxWidth);
                final deviceColumns = AppBreakpoints.columns(constraints.maxWidth, compact: 1, medium: 2, expanded: 3);
                return ListView(
                  padding: padding,
                  children: [
                    const TopGreetingBar(),
                    const SizedBox(height: 16),
                    FilterChips(
                      items: const ['All', 'Living Room', 'Kitchen', 'Drawing'],
                      selected: roomsController.filter,
                      onSelected: (value) {
                        roomsController.setFilter(value);
                        devicesController.setFilterRoom(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (activeEnhancements.isNotEmpty) ...[
                      Text(
                        loc.t('active_features'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final option in activeEnhancements)
                            Chip(
                              avatar: Icon(option.icon, size: 16),
                              label: Text(loc.t(option.chipKey)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FeatureHighlights(
                        settings: settings,
                        devices: devicesController,
                        rooms: roomsController,
                        energy: energy,
                        localization: loc,
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      loc.t('quick_scenes'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final scene in quickScenes)
                          ActionChip(
                            label: Text(scene.label),
                            avatar: Icon(scene.icon, size: 18),
                            onPressed: () async {
                              final key = await devicesController.applyScene(scene.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(loc.t(key))),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    EnergyCapsule(
                      title: '${highlightPoint.kwh} kWh',
                      subtitle: budgetGuard
                          ? loc.t('scene_budget_guard_notice')
                          : loc.t('energy_consumption'),
                      trailing: '${totalKwh} kWh',
                    ),
                    const SizedBox(height: 16),
                    if (rooms.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rooms.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: AppBreakpoints.columns(
                            constraints.maxWidth,
                            compact: 1,
                            medium: 2,
                            expanded: 2,
                          ),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.4,
                        ),
                        itemBuilder: (context, index) {
                          final room = rooms[index];
                          return RoomMiniPanel(
                            title: room.name,
                            devicesSummary: '${room.devicesActive}/${room.devicesTotal}',
                            temperature: '${room.temperature}°C',
                            onPower: () => _toggleRoomPower(context, devicesController, room.id, loc),
                            onLock: () => _showRoomMessage(context, loc.t('room_lock_applied')),
                            onPlan: () => _openRoomDevices(context, room.id, scope),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: featuredDevices.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: deviceColumns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        final device = featuredDevices[index];
                        final energyValue = showEnergy ? devicesController.energyEstimate(device) : null;
                        final batteryValue = showBattery ? 40 + device.id.hashCode.abs() % 60 : null;
                        final status = showHealth
                            ? (device.isOn ? loc.t('device_health_ok') : loc.t('device_health_idle'))
                            : loc.t(device.isOn ? 'status_on' : 'status_off');
                        return DeviceTile(
                          device: device,
                          statusLabel: status,
                          energyKwh: energyValue,
                          batteryLevel: batteryValue,
                          isFavorite: devicesController.isFavorite(device.id),
                          onFavoriteToggle: () => devicesController.toggleFavorite(device.id),
                          onTap: () => _openDevice(context, device),
                          onToggle: (value) => devicesController.toggleDevice(device.id, value),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _openDevice(BuildContext context, Device device) {
    Navigator.of(context).pushNamed(device.type.route, arguments: device.id);
  }

  Future<void> _toggleRoomPower(
    BuildContext context,
    DevicesController controller,
    String roomId,
    AppLocalizations loc,
  ) async {
    final roomDevices = controller.devices.where((device) => device.roomId == roomId);
    for (final device in roomDevices) {
      if (!device.isOn) {
        await controller.toggleDevice(device.id, true);
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.t('room_devices_on'))),
      );
    }
  }

  void _showRoomMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _openRoomDevices(BuildContext context, String roomId, ControllerScope scope) {
    scope.devices.setFilterRoom(roomId);
    Navigator.of(context).pushNamed(AppRoutes.devices);
  }
}

class _SceneAction {
  const _SceneAction({required this.id, required this.icon, required this.label});

  final String id;
  final IconData icon;
  final String label;
}
