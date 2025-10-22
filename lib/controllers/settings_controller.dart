import 'package:flutter/material.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/repositories/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._settingsRepository, this.localization);

  final SettingsRepository _settingsRepository;
  final AppLocalizations localization;

  ThemeMode _themeMode = ThemeMode.system;
  bool _loaded = false;

  ThemeMode get themeMode => _themeMode;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    _themeMode = await _settingsRepository.loadThemeMode();
    _loaded = true;
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _settingsRepository.saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> changeLocale(Locale locale) async {
    await localization.changeLocale(locale);
    notifyListeners();
  }
}
