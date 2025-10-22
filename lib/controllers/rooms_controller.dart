import 'package:flutter/material.dart';
import 'package:smart_home_control/models/room.dart';
import 'package:smart_home_control/repositories/rooms_repository.dart';

class RoomsController extends ChangeNotifier {
  RoomsController(this._repository);

  final RoomsRepository _repository;
  final List<Room> _rooms = [];
  String _filter = 'All';
  bool _loading = false;

  List<Room> get rooms {
    if (_filter == 'All') return List.unmodifiable(_rooms);
    return _rooms.where((room) => room.name.contains(_filter)).toList();
  }

  List<Room> get allRooms => List.unmodifiable(_rooms);

  Room? findById(String id) {
    try {
      return _rooms.firstWhere((room) => room.id == id);
    } catch (_) {
      return null;
    }
  }

  String get filter => _filter;
  bool get isLoading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    final fetched = await _repository.fetchRooms();
    _rooms
      ..clear()
      ..addAll(fetched);
    _loading = false;
    notifyListeners();
  }

  void setFilter(String value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
  }

  Future<void> addRoom(Room room) async {
    await _repository.addRoom(room);
    _rooms.add(room);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _rooms.indexWhere((room) => room.id == id);
    if (index == -1) return;
    final current = _rooms[index];
    final updated = current.copyWith(favorite: !current.favorite);
    await _repository.updateRoom(updated);
    _rooms[index] = updated;
    notifyListeners();
  }
}
