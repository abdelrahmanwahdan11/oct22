import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_control/data/mock_data.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/schedule.dart';

class DevicesRepository {
  DevicesRepository();

  static const _prefsKey = 'devices_v1';
  final List<Device> _devices = [];
  bool _hydrated = false;

  Future<List<Device>> fetchDevices() async {
    await _hydrate();
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_devices);
  }

  Future<void> toggleDevice(String id, bool isOn) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index == -1) return;
    _devices[index] = _devices[index].copyWith(isOn: isOn);
    await _persist();
  }

  Future<void> updateTargetTemp(String id, double target) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index == -1) return;
    _devices[index] = _devices[index].copyWith(targetTemp: target);
    await _persist();
  }

  Future<void> updateMode(String id, String mode) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index == -1) return;
    _devices[index] = _devices[index].copyWith(activeMode: mode);
    await _persist();
  }

  Future<void> updateSchedule(String id, Schedule schedule) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index == -1) return;
    _devices[index] = _devices[index].copyWith(schedule: schedule);
    await _persist();
  }

  Future<void> addDevice(Device device) async {
    _devices.add(device);
    await _persist();
  }

  Future<void> _hydrate() async {
    if (_hydrated) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _devices
        ..clear()
        ..addAll(decoded.map((json) => Device.fromJson(json as Map<String, dynamic>)));
    } else {
      _devices
        ..clear()
        ..addAll(MockData.devices);
      await _persist();
    }
    _hydrated = true;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = _devices.map((device) => device.toJson()).toList();
    await prefs.setString(_prefsKey, jsonEncode(payload));
  }
}
