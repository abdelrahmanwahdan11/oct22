import 'package:flutter/material.dart';

import '../repositories/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._repository);

  final SettingsRepository _repository;

  ThemeSetting _theme = ThemeSetting.light;
  Locale _locale = const Locale('en');
  UnitSystem _unitSystem = UnitSystem.imperial;
  bool _loaded = false;

  ThemeSetting get theme => _theme;
  Locale get locale => _locale;
  UnitSystem get unitSystem => _unitSystem;
  bool get isLoaded => _loaded;

  ThemeMode get themeMode =>
      _theme == ThemeSetting.dark ? ThemeMode.dark : ThemeMode.light;

  bool get isDark => _theme == ThemeSetting.dark;

  Future<void> load() async {
    final data = await _repository.load();
    _theme = data.theme;
    _locale = data.locale;
    _unitSystem = data.unitSystem;
    _loaded = true;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _theme = value ? ThemeSetting.dark : ThemeSetting.light;
    await _repository.saveTheme(_theme);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _repository.saveLocale(locale);
    notifyListeners();
  }

  Future<void> setUnitSystem(UnitSystem system) async {
    _unitSystem = system;
    await _repository.saveUnitSystem(system);
    notifyListeners();
  }
}
