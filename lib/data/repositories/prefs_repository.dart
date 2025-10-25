import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsRepository {
  static const _keyTheme = 'theme';
  static const _keyLocale = 'locale';
  static const _keyWatchlist = 'watchlist';
  static const _keyRecents = 'recent_addresses';
  static const _keySavedFilter = 'saved_filter';
  static const _keyOnboarding = 'onboarding_done';
  static const _keyProMode = 'pref_pro_mode';
  static const _keyBiometric = 'pref_biometric';
  static const _keyDefaultCurrency = 'pref_default_currency';
  static const _keyHighContrast = 'pref_high_contrast';
  static const _keyAutoRefresh = 'pref_auto_refresh';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final existingRecents = _prefs?.getStringList(_keyRecents);
    if (existingRecents == null || existingRecents.isEmpty) {
      await _prefs?.setStringList(_keyRecents, [
        '0x7CB842B...2A1DA4D',
        'bc1pwkf...8K9GM9FZ',
        'BTC',
        'ETH',
      ]);
    }
  }

  bool get isReady => _prefs != null;

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs?.setBool(_keyOnboarding, value);
  }

  bool get onboardingComplete => _prefs?.getBool(_keyOnboarding) ?? false;

  ThemeMode loadThemeMode() {
    final value = _prefs?.getString(_keyTheme);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      _ => 'system',
    };
    await _prefs?.setString(_keyTheme, value);
  }

  Locale? loadLocale() {
    final code = _prefs?.getString(_keyLocale);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> saveLocale(Locale locale) async {
    await _prefs?.setString(_keyLocale, locale.languageCode);
  }

  List<String> loadWatchlist() {
    return _prefs?.getStringList(_keyWatchlist) ?? <String>[];
  }

  Future<void> saveWatchlist(List<String> watchlist) async {
    await _prefs?.setStringList(_keyWatchlist, watchlist);
  }

  Future<List<String>> toggleWatch(String assetId) async {
    final current = loadWatchlist();
    if (current.contains(assetId)) {
      current.remove(assetId);
    } else {
      current.add(assetId);
    }
    await saveWatchlist(current);
    return current;
  }

  List<String> loadRecents() {
    return _prefs?.getStringList(_keyRecents) ?? <String>[];
  }

  Future<void> addRecent(String value) async {
    final current = loadRecents();
    current.remove(value);
    current.insert(0, value);
    if (current.length > 10) {
      current.removeRange(10, current.length);
    }
    await _prefs?.setStringList(_keyRecents, current);
  }

  Map<String, dynamic>? loadSavedFilter() {
    final jsonString = _prefs?.getString(_keySavedFilter);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<void> saveFilter(Map<String, dynamic> filter) async {
    await _prefs?.setString(_keySavedFilter, json.encode(filter));
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }

  bool loadProMode() => _prefs?.getBool(_keyProMode) ?? true;
  Future<void> saveProMode(bool value) async => _prefs?.setBool(_keyProMode, value);

  bool loadBiometric() => _prefs?.getBool(_keyBiometric) ?? false;
  Future<void> saveBiometric(bool value) async => _prefs?.setBool(_keyBiometric, value);

  String loadDefaultCurrency() => _prefs?.getString(_keyDefaultCurrency) ?? 'USD';
  Future<void> saveDefaultCurrency(String value) async => _prefs?.setString(_keyDefaultCurrency, value);

  bool loadHighContrast() => _prefs?.getBool(_keyHighContrast) ?? false;
  Future<void> saveHighContrast(bool value) async => _prefs?.setBool(_keyHighContrast, value);

  bool loadAutoRefresh() => _prefs?.getBool(_keyAutoRefresh) ?? true;
  Future<void> saveAutoRefresh(bool value) async => _prefs?.setBool(_keyAutoRefresh, value);
}
