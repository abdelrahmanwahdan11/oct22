import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';
import '../data/repositories/prefs_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefsRepository);

  final PrefsRepository _prefsRepository;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = AppLocalizations.defaultLocale;
  bool _onboardingComplete = false;
  int _accentIndex = 0;
  double _textScale = 1.0;
  Map<String, bool> _featureToggles = {};

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get onboardingComplete => _onboardingComplete;
  int get accentIndex => _accentIndex;
  double get textScale => _textScale;

  static const Map<String, bool> _defaultFeatureMap = {
    'show_saved_filters': true,
    'show_neighborhood_guides': true,
    'show_virtual_tours': true,
    'show_events': true,
    'show_service_directory': true,
    'show_market_headlines': true,
    'show_sustainability_toggle': true,
    'show_price_per_m2': true,
    'enable_notifications': true,
    'enable_biometrics': false,
    'auto_play_tours': true,
    'sustainability_focus': false,
    'agent_recommendations': true,
    'compare_tool': true,
    'alert_center': true,
    'notes_manager': true,
    'export_tools': true,
    'concierge_shortcuts': true,
    'milestones_tracker': true,
    'market_digest': true,
    'safety_reminders': true,
    'sustainability_highlights': true,
    'investment_tips': true,
    'success_stories': true,
    'renovation_tasks': true,
    'insurance_offers': true,
    'maintenance_schedule': true,
    'guarantee_programs': true,
    'service_directory_home': true,
    'top_agents': true,
  };

  bool featureEnabled(String key) =>
      _featureToggles[key] ?? _defaultFeatureMap[key] ?? false;

  Future<void> load() async {
    final theme = await _prefsRepository.loadThemeMode();
    final localeCode = await _prefsRepository.loadLocale();
    _onboardingComplete = await _prefsRepository.isOnboardingDone();
    _accentIndex = await _prefsRepository.loadAccentIndex();
    _textScale = await _prefsRepository.loadTextScale();
    final storedToggles = await _prefsRepository.loadFeatureToggles();
    _featureToggles = {..._defaultFeatureMap, ...storedToggles};

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

  Future<void> setAccentIndex(int index) async {
    if (_accentIndex == index) return;
    _accentIndex = index;
    await _prefsRepository.saveAccentIndex(index);
    notifyListeners();
  }

  Future<void> setTextScale(double value) async {
    if ((value - _textScale).abs() < 0.01) return;
    _textScale = value;
    await _prefsRepository.saveTextScale(value);
    notifyListeners();
  }

  Future<void> setFeatureToggle(String key, bool value) async {
    _featureToggles[key] = value;
    await _prefsRepository.saveFeatureToggles(_featureToggles);
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
    _accentIndex = 0;
    _textScale = 1.0;
    _featureToggles = Map<String, bool>.from(_defaultFeatureMap);
    notifyListeners();
  }
}
