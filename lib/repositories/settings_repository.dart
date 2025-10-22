import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_control/models/access_rule.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/schedule.dart';

class SettingsRepository {
  static const _themeKey = 'theme_mode';
  static const _accessRulesKey = 'access_rules_v1';
  static const _schedulesKey = 'schedules_v1';

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);
    switch (themeString) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_themeKey, value);
  }

  Future<List<AccessRule>> loadAccessRules(List<AccessRule> seed) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_accessRulesKey);
    if (raw == null) return seed;
    final json = jsonDecode(raw) as List<dynamic>;
    return json
        .map((item) {
          final map = item as Map<String, dynamic>;
          final match = seed.firstWhere(
            (rule) => rule.id == map['id'],
            orElse: () => AccessRule(
              id: map['id'] as String,
              title: map['title'] as String? ?? '',
              description: map['description'] as String? ?? '',
              enabled: map['enabled'] as bool? ?? false,
              visibility: map['visibility'] as String? ?? 'members',
            ),
          );
          return match.copyWith(enabled: map['enabled'] as bool? ?? match.enabled);
        })
        .toList();
  }

  Future<void> saveAccessRules(List<AccessRule> rules) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = rules
        .map((rule) => {
              'id': rule.id,
              'title': rule.title,
              'description': rule.description,
              'enabled': rule.enabled,
              'visibility': rule.visibility,
            })
        .toList();
    await prefs.setString(_accessRulesKey, jsonEncode(payload));
  }

  Future<Map<String, Schedule>> loadSchedules(List<Device> devices) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_schedulesKey);
    if (raw == null) {
      return {
        for (final device in devices)
          if (device.schedule != null) device.id: device.schedule!
      };
    }
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return json.map((key, value) {
      final map = value as Map<String, dynamic>;
      return MapEntry(
        key,
        Schedule(
          id: map['id'] as String,
          deviceId: map['deviceId'] as String,
          enabled: map['enabled'] as bool? ?? false,
          start: map['start'] as String? ?? '',
          end: map['end'] as String? ?? '',
          repeat: (map['repeat'] as List<dynamic>? ?? []).cast<String>(),
        ),
      );
    });
  }

  Future<void> saveSchedule(String deviceId, Schedule schedule) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_schedulesKey);
    final map = raw == null
        ? <String, dynamic>{}
        : jsonDecode(raw) as Map<String, dynamic>;
    map[deviceId] = {
      'id': schedule.id,
      'deviceId': schedule.deviceId,
      'enabled': schedule.enabled,
      'start': schedule.start,
      'end': schedule.end,
      'repeat': schedule.repeat,
    };
    await prefs.setString(_schedulesKey, jsonEncode(map));
  }
}
