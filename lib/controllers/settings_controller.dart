import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';
import '../data/repositories/prefs_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefsRepository);

  final PrefsRepository _prefsRepository;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = AppLocalizations.defaultLocale;
  bool _onboardingComplete = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get onboardingComplete => _onboardingComplete;

  Future<void> load() async {
    final theme = await _prefsRepository.loadThemeMode();
    final localeCode = await _prefsRepository.loadLocale();
    _onboardingComplete = await _prefsRepository.isOnboardingDone();

    if (theme != null) {
      _themeMode = theme == 'dark'
          ? ThemeMode.dark
          : theme == 'light'
              ? ThemeMode.light
              : ThemeMode.system;
    }
    if (localeCode != null) {
      _locale = Locale(localeCode);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefsRepository.saveThemeMode(
      mode == ThemeMode.dark
          ? 'dark'
          : mode == ThemeMode.light
              ? 'light'
              : 'system',
    );
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool enabled) async {
    await setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefsRepository.saveLocale(locale.languageCode);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    await _prefsRepository.setOnboardingDone();
    notifyListeners();
  }

  Future<void> clear() async {
    await _prefsRepository.clear();
    _themeMode = ThemeMode.system;
    _locale = AppLocalizations.defaultLocale;
    _onboardingComplete = false;
    notifyListeners();
  }
}
