import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';
import '../data/repositories/prefs_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this.prefsRepository);

  final PrefsRepository prefsRepository;

  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = AppLocalizations.defaultLocale;
  bool _onboardingComplete = false;
  bool _proMode = true;
  bool _biometric = false;
  bool _highContrast = false;
  bool _autoRefreshPortfolio = true;
  String _defaultCurrency = 'USD';

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get onboardingComplete => _onboardingComplete;
  bool get proMode => _proMode;
  bool get biometricEnabled => _biometric;
  bool get highContrast => _highContrast;
  bool get autoRefreshPortfolio => _autoRefreshPortfolio;
  String get defaultCurrency => _defaultCurrency;

  Future<void> load() async {
    if (!prefsRepository.isReady) {
      await prefsRepository.init();
    }
    _themeMode = prefsRepository.loadThemeMode();
    _locale = prefsRepository.loadLocale() ?? AppLocalizations.defaultLocale;
    _onboardingComplete = prefsRepository.onboardingComplete;
    _proMode = prefsRepository.loadProMode();
    _biometric = prefsRepository.loadBiometric();
    _highContrast = prefsRepository.loadHighContrast();
    _autoRefreshPortfolio = prefsRepository.loadAutoRefresh();
    _defaultCurrency = prefsRepository.loadDefaultCurrency();
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

  Future<void> setProMode(bool value) async {
    _proMode = value;
    await prefsRepository.saveProMode(value);
    notifyListeners();
  }

  Future<void> setBiometric(bool value) async {
    _biometric = value;
    await prefsRepository.saveBiometric(value);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    await prefsRepository.saveHighContrast(value);
    notifyListeners();
  }

  Future<void> setAutoRefresh(bool value) async {
    _autoRefreshPortfolio = value;
    await prefsRepository.saveAutoRefresh(value);
    notifyListeners();
  }

  Future<void> setDefaultCurrency(String value) async {
    _defaultCurrency = value;
    await prefsRepository.saveDefaultCurrency(value);
    notifyListeners();
  }
}
