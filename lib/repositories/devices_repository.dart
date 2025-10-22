import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_control/data/mock_data.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/schedule.dart';

class DevicesRepository {
  DevicesRepository();

  static const _prefsKey = 'devices_v1';
  final List<Device> _devices = List.of(MockData.devices);
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
      for (final json in decoded) {
        final map = json as Map<String, dynamic>;
        final index = _devices.indexWhere((device) => device.id == map['id']);
        if (index != -1) {
          _devices[index] = _devices[index].copyWith(
            isOn: map['isOn'] as bool?,
            targetTemp: (map['targetTemp'] as num?)?.toDouble(),
            schedule: _decodeSchedule(map['schedule'] as Map<String, dynamic>?),
            activeMode: map['activeMode'] as String?,
          );
        }
      }
    }
    _hydrated = true;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = _devices
        .map((device) => {
              'id': device.id,
              'isOn': device.isOn,
              'targetTemp': device.targetTemp,
              'schedule': _encodeSchedule(device.schedule),
              'activeMode': device.activeMode,
            })
        .toList();
    await prefs.setString(_prefsKey, jsonEncode(payload));
  }

  Map<String, dynamic>? _encodeSchedule(Schedule? schedule) {
    if (schedule == null) return null;
    return {
      'id': schedule.id,
      'deviceId': schedule.deviceId,
      'enabled': schedule.enabled,
      'start': schedule.start,
      'end': schedule.end,
      'repeat': schedule.repeat,
    };
  }

  Schedule? _decodeSchedule(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Schedule(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      enabled: json['enabled'] as bool? ?? false,
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      repeat: (json['repeat'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}
