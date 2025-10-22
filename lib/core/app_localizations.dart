import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations extends ChangeNotifier {
  AppLocalizations(this._locale) {
    _strings = _localizedValues[_locale.languageCode] ?? _localizedValues['en']!;
  }

  static const supportedLocales = [Locale('en'), Locale('ar')];
  static const _prefKey = 'locale';

  Locale _locale;
  late Map<String, String> _strings;

  Locale get locale => _locale;
  Map<String, String> get strings => _strings;

  static const _localizedValues = {
    'en': {
      'rooms': 'My Rooms',
      'devices': 'My Device',
      'energy_consumption': 'Energy Consumption',
      'search_device': 'Search Device',
      'add_device': 'Add Device',
      'add_room': 'Add Room',
    },
    'ar': {
      'rooms': 'غرفي',
      'devices': 'أجهزتي',
      'energy_consumption': 'استهلاك الطاقة',
      'search_device': 'ابحث عن جهاز',
      'add_device': 'أضف جهاز',
      'add_room': 'أضف غرفة',
    },
  };

  static Future<AppLocalizations> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey) ?? 'en';
    return AppLocalizations(Locale(code));
  }

  Future<void> changeLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    _strings = _localizedValues[_locale.languageCode] ?? _localizedValues['en']!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, _locale.languageCode);
    notifyListeners();
  }
}
