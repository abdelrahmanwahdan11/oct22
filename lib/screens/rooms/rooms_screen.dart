import 'package:flutter/material.dart';
import 'package:smart_home_control/core/app_router.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/core/responsive.dart';
import 'package:smart_home_control/models/room.dart';
import 'package:smart_home_control/widgets/energy_capsule.dart';
import 'package:smart_home_control/widgets/filter_chips.dart';
import 'package:smart_home_control/widgets/room_card_large.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final listenable = Listenable.merge([scope.rooms, scope.auth, scope.settings]);
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final rooms = scope.rooms.rooms;
        final loc = scope.auth.localization;
        final settings = scope.settings;
        final budgetGuard = settings.isEnhancementEnabled('vacation_mode');
        final roomsLabel = loc.t('label_rooms_generic');
        final onlineLabel = loc.t('label_online_generic');
        return Scaffold(
          appBar: AppBar(title: Text(loc.t('rooms'))),
          body: SafeArea(
            child: ResponsiveConstrainedBox(
              builder: (context, constraints) {
                final padding = AppBreakpoints.geometry(constraints.maxWidth);
                return Padding(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilterChips(
                        items: const ['All', 'Living Room', 'Kitchen', 'Drawing'],
                        selected: scope.rooms.filter,
                        onSelected: scope.rooms.setFilter,
                      ),
                      const SizedBox(height: 12),
                      EnergyCapsule(
                        title: loc.t('energy_consumption'),
                        subtitle: rooms.isEmpty
                            ? loc.t('no_devices_found')
                            : '${rooms.length} $roomsLabel',
                        trailing:
                            '${rooms.fold<int>(0, (sum, room) => sum + room.devicesActive)} $onlineLabel',
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.roomsCarousel),
                        icon: const Icon(Icons.view_carousel),
                        label: Text(loc.t('open_room_carousel')),
                      ),
                      if (budgetGuard) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.flight_takeoff, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  loc.t('feature_vacation_mode_subtitle'),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Expanded(
                        child: rooms.isEmpty
                            ? Center(child: Text(loc.t('no_devices_found')))
                            : ListView.separated(
                                itemCount: rooms.length,
                                itemBuilder: (context, index) {
                                  final room = rooms[index];
                                  return RoomCardLarge(
                                    room: room,
                                    index: index,
                                    onTap: () => _openRoomDetail(context, scope, room),
                                  );
                                },
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                              ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _showAddRoomSheet(context, scope),
                        icon: const Icon(Icons.add),
                        label: Text(loc.t('add_room')),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddRoomSheet(BuildContext context, ControllerScope scope) async {
    final loc = scope.auth.localization;
    final nameController = TextEditingController();
    final devicesController = TextEditingController(text: '0');
    final temperatureController = TextEditingController(text: '24');
    String selectedPhoto = 'assets/images/room_living.jpg';

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.t('add_room'), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: loc.t('add_room_name_hint')),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedPhoto,
                    decoration: InputDecoration(labelText: loc.t('add_room_photo')),
                    items: const [
                      DropdownMenuItem(value: 'assets/images/room_living.jpg', child: Text('Living Room')),
                      DropdownMenuItem(value: 'assets/images/room_kitchen.jpg', child: Text('Kitchen')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => selectedPhoto = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: devicesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: loc.t('add_room_devices_total')),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: temperatureController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: loc.t('add_room_temperature_hint')),
                  ),
                  const SizedBox(height: 20),
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
                          child: Text(loc.t('add_room_create')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (confirmed == true) {
      final name = nameController.text.trim();
      final devicesTotal = int.tryParse(devicesController.text) ?? 0;
      final temperature = int.tryParse(temperatureController.text) ?? 24;
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.t('name_required'))),
        );
        return;
      }
      final room = Room(
        id: 'room_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        photo: selectedPhoto,
        devicesTotal: devicesTotal,
        devicesActive: 0,
        temperature: temperature,
        favorite: false,
        devices: const [],
      );
      await scope.rooms.addRoom(room);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.t('room_added_success'))),
        );
      }
    }

    nameController.dispose();
    devicesController.dispose();
    temperatureController.dispose();
  }

  Future<void> _openRoomDetail(BuildContext context, ControllerScope scope, Room room) async {
    final loc = scope.auth.localization;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text('${loc.t('feature_device_health_title')}: ${room.devicesActive}/${room.devicesTotal}'),
              const SizedBox(height: 8),
              Text('${loc.t('feature_air_quality_watch_title')}: ${room.temperature}°C'),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: room.favorite,
                title: Text(loc.t('feature_shared_alerts_title')),
                subtitle: Text(loc.t('feature_shared_alerts_subtitle')),
                onChanged: (_) async {
                  await scope.rooms.toggleFavorite(room.id);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.devices_other_outlined),
                title: Text(loc.t('devices')),
                subtitle: Text(loc.t('add_device_catalog')),
                onTap: () {
                  Navigator.of(context).pop();
                  scope.devices.setFilterRoom(room.id);
                  Navigator.of(context).pushNamed(AppRoutes.devices);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_location_outlined),
                title: Text(loc.t('scene_away')),
                subtitle: Text(loc.t('feature_vacation_mode_subtitle')),
                onTap: () async {
                  Navigator.of(context).pop();
                  final summary = await scope.devices.applyScene('away');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.t(summary))),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
