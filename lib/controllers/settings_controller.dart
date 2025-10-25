import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';
import '../data/repositories/prefs_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this.prefsRepository);

  final PrefsRepository prefsRepository;

  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = AppLocalizations.defaultLocale;
  bool _onboardingComplete = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get onboardingComplete => _onboardingComplete;

  Future<void> load() async {
    await prefsRepository.init();
    _themeMode = prefsRepository.loadThemeMode();
    _locale = prefsRepository.loadLocale() ?? AppLocalizations.defaultLocale;
    _onboardingComplete = prefsRepository.onboardingComplete;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    await prefsRepository.saveThemeMode(_themeMode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await prefsRepository.saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await prefsRepository.saveLocale(locale);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    await prefsRepository.setOnboardingComplete(true);
    notifyListeners();
  }

  Future<void> clearLocal() async {
    await prefsRepository.clear();
    await load();
  }
}
