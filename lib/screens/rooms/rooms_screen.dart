import 'package:flutter/material.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/models/room.dart';
import 'package:smart_home_control/widgets/energy_capsule.dart';
import 'package:smart_home_control/widgets/filter_chips.dart';
import 'package:smart_home_control/widgets/room_card_large.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final listenable = Listenable.merge([scope.rooms, scope.auth]);
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final rooms = scope.rooms.rooms;
        final loc = scope.auth.localization;
        return Scaffold(
          appBar: AppBar(title: Text(loc.t('rooms'))),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                    subtitle: loc.t('energy_analysis'),
                    trailing: '1962kwh',
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return RoomCardLarge(
                          room: room,
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: Text(loc.t('add_room')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
