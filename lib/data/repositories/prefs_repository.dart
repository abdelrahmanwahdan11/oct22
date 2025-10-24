import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsRepository {
  static const _themeKey = 'theme';
  static const _localeKey = 'locale';
  static const _favoritesKey = 'favorites';
  static const _savedFilterKey = 'saved_filter';
  static const _onboardingKey = 'onboarding_done';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<String?> loadThemeMode() async {
    await init();
    return _prefs!.getString(_themeKey);
  }

  Future<void> saveThemeMode(String mode) async {
    await init();
    await _prefs!.setString(_themeKey, mode);
  }

  Future<String?> loadLocale() async {
    await init();
    return _prefs!.getString(_localeKey);
  }

  Future<void> saveLocale(String locale) async {
    await init();
    await _prefs!.setString(_localeKey, locale);
  }

  Future<Set<String>> loadFavorites() async {
    await init();
    final list = _prefs!.getStringList(_favoritesKey) ?? <String>[];
    return list.toSet();
  }

  Future<void> saveFavorites(Set<String> ids) async {
    await init();
    await _prefs!.setStringList(_favoritesKey, ids.toList());
  }

  Future<Map<String, dynamic>?> loadSavedFilter() async {
    await init();
    final jsonString = _prefs!.getString(_savedFilterKey);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<void> saveFilter(Map<String, dynamic> value) async {
    await init();
    await _prefs!.setString(_savedFilterKey, json.encode(value));
  }

  Future<void> clear() async {
    await init();
    await _prefs!.clear();
  }

  Future<bool> isOnboardingDone() async {
    await init();
    return _prefs!.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingDone() async {
    await init();
    await _prefs!.setBool(_onboardingKey, true);
  }
}
