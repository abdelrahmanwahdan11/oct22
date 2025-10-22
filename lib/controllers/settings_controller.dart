import 'package:flutter/material.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/core/feature_catalog.dart';
import 'package:smart_home_control/repositories/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._settingsRepository, this.localization);

  final SettingsRepository _settingsRepository;
  final AppLocalizations localization;

  ThemeMode _themeMode = ThemeMode.system;
  bool _loaded = false;
  final Map<String, bool> _enhancements = {
    for (final option in enhancementCatalog) option.id: option.defaultEnabled,
  };

  ThemeMode get themeMode => _themeMode;
  bool get isLoaded => _loaded;
  Map<String, bool> get enhancements => Map.unmodifiable(_enhancements);
  Iterable<String> get activeEnhancementIds =>
      _enhancements.entries.where((entry) => entry.value).map((entry) => entry.key);
  bool isEnhancementEnabled(String id) => _enhancements[id] ?? false;

  Future<void> load() async {
    _themeMode = await _settingsRepository.loadThemeMode();
    final map = await _settingsRepository
        .loadEnhancements([for (final option in enhancementCatalog) option.id]);
    _enhancements
      ..clear()
      ..addAll(map);
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

  Future<void> toggleEnhancement(String id, bool value) async {
    if (_enhancements[id] == value) return;
    _enhancements[id] = value;
    await _settingsRepository.saveEnhancements(_enhancements);
    notifyListeners();
  }
}
