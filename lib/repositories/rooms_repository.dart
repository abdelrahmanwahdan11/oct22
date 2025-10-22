import 'dart:async';

import 'package:smart_home_control/data/mock_data.dart';
import 'package:smart_home_control/models/room.dart';

class RoomsRepository {
  RoomsRepository();

  final List<Room> _rooms = List.of(MockData.rooms);

  Future<List<Room>> fetchRooms() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return List.unmodifiable(_rooms);
  }

  Future<void> addRoom(Room room) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _rooms.add(room);
  }
}
