import 'package:shared_preferences/shared_preferences.dart';

class PrefsRepository {
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _onboardingKey = 'onboarding_done';
  static const _remindersKey = 'reminders_enabled';
  static const _filtersKey = 'saved_filters';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs?.setString(_themeKey, mode);
  }

  String? getThemeMode() => _prefs?.getString(_themeKey);

  Future<void> setLocale(String locale) async {
    await _prefs?.setString(_localeKey, locale);
  }

  String? getLocale() => _prefs?.getString(_localeKey);

  Future<void> setOnboardingDone(bool value) async {
    await _prefs?.setBool(_onboardingKey, value);
  }

  bool getOnboardingDone() => _prefs?.getBool(_onboardingKey) ?? false;

  Future<void> setRemindersEnabled(bool value) async {
    await _prefs?.setBool(_remindersKey, value);
  }

  bool getRemindersEnabled() => _prefs?.getBool(_remindersKey) ?? true;

  Future<void> saveFilters(List<String> filters) async {
    await _prefs?.setStringList(_filtersKey, filters);
  }

  List<String> getFilters() => _prefs?.getStringList(_filtersKey) ?? <String>[];
}
