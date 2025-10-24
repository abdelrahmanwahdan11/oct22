import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsRepository {
  static const _themeKey = 'theme';
  static const _localeKey = 'locale';
  static const _favoritesKey = 'favorites';
  static const _savedFilterKey = 'saved_filter';
  static const _onboardingKey = 'onboarding_done';
  static const _rememberMeKey = 'remember_me';
  static const _rememberedEmailKey = 'remembered_email';
  static const _recentSearchesKey = 'recent_searches';
  static const _recentViewsKey = 'recent_views';
  static const _submittedPropertiesKey = 'submitted_properties';
  static const _compareKey = 'compare_properties';
  static const _favoriteNotesKey = 'favorite_notes';
  static const _savedAlertsKey = 'saved_alerts';
  static const _accentKey = 'accent_index';
  static const _textScaleKey = 'text_scale';
  static const _featureTogglesKey = 'feature_toggles';

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

  Future<bool> loadRememberMe() async {
    await init();
    return _prefs!.getBool(_rememberMeKey) ?? false;
  }

  Future<void> saveRememberMe(bool value) async {
    await init();
    await _prefs!.setBool(_rememberMeKey, value);
  }

  Future<String?> loadRememberedEmail() async {
    await init();
    return _prefs!.getString(_rememberedEmailKey);
  }

  Future<void> saveRememberedEmail(String? value) async {
    await init();
    if (value == null || value.isEmpty) {
      await _prefs!.remove(_rememberedEmailKey);
      return;
    }
    await _prefs!.setString(_rememberedEmailKey, value);
  }

  Future<List<String>> loadRecentSearches() async {
    await init();
    return _prefs!.getStringList(_recentSearchesKey) ?? <String>[];
  }

  Future<void> addRecentSearch(String value) async {
    if (value.isEmpty) return;
    await init();
    final current = _prefs!.getStringList(_recentSearchesKey) ?? <String>[];
    current.remove(value);
    current.insert(0, value);
    final limited = current.take(10).toList();
    await _prefs!.setStringList(_recentSearchesKey, limited);
  }

  Future<List<String>> loadRecentViews() async {
    await init();
    return _prefs!.getStringList(_recentViewsKey) ?? <String>[];
  }

  Future<void> addRecentView(String id) async {
    await init();
    final current = _prefs!.getStringList(_recentViewsKey) ?? <String>[];
    current.remove(id);
    current.insert(0, id);
    final limited = current.take(12).toList();
    await _prefs!.setStringList(_recentViewsKey, limited);
  }

  Future<List<Map<String, dynamic>>> loadSubmittedProperties() async {
    await init();
    final raw = _prefs!.getStringList(_submittedPropertiesKey) ?? <String>[];
    return raw
        .map((item) => json.decode(item) as Map<String, dynamic>)
        .toList();
  }

  Future<void> addSubmittedProperty(Map<String, dynamic> jsonMap) async {
    await init();
    final raw = _prefs!.getStringList(_submittedPropertiesKey) ?? <String>[];
    raw.insert(0, json.encode(jsonMap));
    final limited = raw.take(25).toList();
    await _prefs!.setStringList(_submittedPropertiesKey, limited);
  }

  Future<Set<String>> loadCompare() async {
    await init();
    final list = _prefs!.getStringList(_compareKey) ?? <String>[];
    return list.toSet();
  }

  Future<void> saveCompare(Set<String> ids) async {
    await init();
    await _prefs!.setStringList(_compareKey, ids.toList());
  }

  Future<Map<String, String>> loadFavoriteNotes() async {
    await init();
    final raw = _prefs!.getString(_favoriteNotesKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    final decoded = json.decode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<void> saveFavoriteNotes(Map<String, String> notes) async {
    await init();
    if (notes.isEmpty) {
      await _prefs!.remove(_favoriteNotesKey);
      return;
    }
    await _prefs!.setString(_favoriteNotesKey, json.encode(notes));
  }

  Future<Set<String>> loadSavedAlerts() async {
    await init();
    final list = _prefs!.getStringList(_savedAlertsKey) ?? <String>[];
    return list.toSet();
  }

  Future<void> saveSavedAlerts(Set<String> ids) async {
    await init();
    await _prefs!.setStringList(_savedAlertsKey, ids.toList());
  }

  Future<int> loadAccentIndex() async {
    await init();
    return _prefs!.getInt(_accentKey) ?? 0;
  }

  Future<void> saveAccentIndex(int index) async {
    await init();
    await _prefs!.setInt(_accentKey, index);
  }

  Future<double> loadTextScale() async {
    await init();
    return _prefs!.getDouble(_textScaleKey) ?? 1.0;
  }

  Future<void> saveTextScale(double value) async {
    await init();
    await _prefs!.setDouble(_textScaleKey, value);
  }

  Future<Map<String, bool>> loadFeatureToggles() async {
    await init();
    final raw = _prefs!.getString(_featureTogglesKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    final decoded = json.decode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value == true));
  }

  Future<void> saveFeatureToggles(Map<String, bool> toggles) async {
    await init();
    if (toggles.isEmpty) {
      await _prefs!.remove(_featureTogglesKey);
      return;
    }
    await _prefs!.setString(_featureTogglesKey, json.encode(toggles));
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
