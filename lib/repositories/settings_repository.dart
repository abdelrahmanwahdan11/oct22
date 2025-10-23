import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UnitSystem { imperial, metric }

enum ThemeSetting { light, dark }

class SettingsRepository {
  static const _themeKey = 'theme';
  static const _localeKey = 'locale';
  static const _unitKey = 'unitSystem';

  Future<SettingsData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeRaw = prefs.getString(_themeKey);
    final localeRaw = prefs.getString(_localeKey);
    final unitRaw = prefs.getString(_unitKey);

    final theme = ThemeSetting.values.firstWhere(
      (value) => value.name == themeRaw,
      orElse: () => ThemeSetting.light,
    );

    final locale = _decodeLocale(localeRaw) ?? const Locale('en');

    final unitSystem = UnitSystem.values.firstWhere(
      (value) => value.name == unitRaw,
      orElse: () => UnitSystem.imperial,
    );

    return SettingsData(
      theme: theme,
      locale: locale,
      unitSystem: unitSystem,
    );
  }

  Future<void> saveTheme(ThemeSetting theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.name);
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, _encodeLocale(locale));
  }

  Future<void> saveUnitSystem(UnitSystem system) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, system.name);
  }

  String _encodeLocale(Locale locale) {
    return [locale.languageCode, if (locale.countryCode != null) locale.countryCode]
        .whereType<String>()
        .join('_');
  }

  Locale? _decodeLocale(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final parts = value.split('_');
    if (parts.isEmpty) {
      return null;
    }
    if (parts.length == 1) {
      return Locale(parts[0]);
    }
    return Locale(parts[0], parts[1]);
  }
}

class SettingsData {
  const SettingsData({
    required this.theme,
    required this.locale,
    required this.unitSystem,
  });

  final ThemeSetting theme;
  final Locale locale;
  final UnitSystem unitSystem;
}
