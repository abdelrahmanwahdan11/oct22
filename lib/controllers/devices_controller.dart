import 'package:flutter/material.dart';
import 'package:smart_home_control/data/mock_data.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/device_template.dart';
import 'package:smart_home_control/models/schedule.dart';
import 'package:smart_home_control/repositories/devices_repository.dart';
import 'package:smart_home_control/repositories/settings_repository.dart';

class DevicesController extends ChangeNotifier {
  DevicesController(this._repository, this._settingsRepository);

  final DevicesRepository _repository;
  final SettingsRepository _settingsRepository;
  final List<Device> _devices = [];
  String _search = '';
  String _filterRoom = 'All';
  bool _loading = false;
  final Map<String, Schedule> _schedules = {};
  final Map<String, String> _roomNames = {
    for (final room in MockData.rooms) room.id: room.name,
  };

  List<Device> get devices {
    Iterable<Device> list = _devices;
    if (_filterRoom != 'All') {
      list = list.where((device) {
        final roomName = _roomNames[device.roomId];
        return device.roomId == _filterRoom || roomName == _filterRoom;
      });
    }
    if (_search.isNotEmpty) {
      list = list.where((device) =>
          device.name.toLowerCase().contains(_search.toLowerCase()));
    }
    return list.toList();
  }

  bool get isLoading => _loading;
  String get search => _search;
  String get filterRoom => _filterRoom;
  List<DeviceTemplate> get catalog => List.unmodifiable(MockData.deviceCatalog);

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    final fetched = await _repository.fetchDevices();
    _devices
      ..clear()
      ..addAll(fetched);
    final storedSchedules = await _settingsRepository.loadSchedules(_devices);
    _schedules
      ..clear()
      ..addAll(storedSchedules);
    _loading = false;
    notifyListeners();
  }

  Schedule? scheduleFor(String id) => _schedules[id];

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void setFilterRoom(String value) {
    _filterRoom = value;
    notifyListeners();
  }

  Future<void> toggleDevice(String id, bool isOn) async {
    await _repository.toggleDevice(id, isOn);
    final index = _devices.indexWhere((device) => device.id == id);
    if (index != -1) {
      _devices[index] = _devices[index].copyWith(isOn: isOn);
      notifyListeners();
    }
  }

  Future<Device> addFromTemplate(
    DeviceTemplate template,
    String roomId, {
    String? roomName,
  }) async {
    final id = 'cd_${DateTime.now().millisecondsSinceEpoch}';
    final device = Device(
      id: id,
      name: template.name,
      type: template.type,
      roomId: roomId,
      image: template.image,
      isOn: false,
      modes: template.modes,
      temperature: template.temperature,
      targetTemp: template.targetTemp,
    );
    await _repository.addDevice(device);
    _devices.add(device);
    if (roomName != null) {
      _roomNames[roomId] = roomName;
    }
    notifyListeners();
    return device;
  }

  Future<void> setTargetTemperature(String id, double target) async {
    await _repository.updateTargetTemp(id, target);
    final index = _devices.indexWhere((device) => device.id == id);
    if (index != -1) {
      _devices[index] = _devices[index].copyWith(targetTemp: target);
      notifyListeners();
    }
  }

  Future<void> updateSchedule(String id, Schedule schedule) async {
    await _repository.updateSchedule(id, schedule);
    await _settingsRepository.saveSchedule(id, schedule);
    _schedules[id] = schedule;
    notifyListeners();
  }

  Future<void> setMode(String id, String mode) async {
    await _repository.updateMode(id, mode);
    final index = _devices.indexWhere((device) => device.id == id);
    if (index != -1) {
      _devices[index] = _devices[index].copyWith(activeMode: mode);
      notifyListeners();
    }
  }

  Device? findById(String? id) {
    if (id == null) return null;
    try {
      return _devices.firstWhere((device) => device.id == id);
    } catch (_) {
      return null;
    }
  }
}
