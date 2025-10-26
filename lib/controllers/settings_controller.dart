import 'package:flutter/material.dart';

import '../data/repositories/prefs_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefsRepository);

  final PrefsRepository _prefsRepository;

  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ar');
  bool _remindersEnabled = true;
  bool _onboardingDone = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get remindersEnabled => _remindersEnabled;
  bool get onboardingDone => _onboardingDone;

  Future<void> load() async {
    await _prefsRepository.init();
    final themeValue = _prefsRepository.getThemeMode();
    if (themeValue == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }

    final savedLocale = _prefsRepository.getLocale();
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }

    _remindersEnabled = _prefsRepository.getRemindersEnabled();
    _onboardingDone = _prefsRepository.getOnboardingDone();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _prefsRepository.setThemeMode(_themeMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> changeLocale(Locale locale) async {
    _locale = locale;
    await _prefsRepository.setLocale(locale.languageCode);
    notifyListeners();
  }

  Future<void> setRemindersEnabled(bool value) async {
    _remindersEnabled = value;
    await _prefsRepository.setRemindersEnabled(value);
    notifyListeners();
  }

  Future<void> setOnboardingDone(bool value) async {
    _onboardingDone = value;
    await _prefsRepository.setOnboardingDone(value);
    notifyListeners();
  }
}
