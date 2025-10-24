import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;
  late final Map<String, String> _strings;

  static const supportedLocales = [Locale('ar'), Locale('en')];
  static const defaultLocale = Locale('ar');

  static Future<AppLocalizations> load(Locale locale) async {
    final data = await rootBundle
        .loadString('assets/l10n/${locale.languageCode}.json')
        .catchError((_) => rootBundle
            .loadString('assets/l10n/${defaultLocale.languageCode}.json'));
    final map = json.decode(data) as Map<String, dynamic>;
    final loc = AppLocalizations(locale);
    loc._strings = map.map((key, value) => MapEntry(key, value.toString()));
    return loc;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        (throw FlutterError('AppLocalizations not found in widget tree'));
  }

  String t(String key) => _strings[key] ?? key;

  bool get isRtl => locale.languageCode == 'ar';

  String get languageCode => locale.languageCode;
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales
          .map((l) => l.languageCode)
          .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

extension AppLocalizationExtension on BuildContext {
  AppLocalizations get strings => AppLocalizations.of(this);

  String t(String key) => strings.t(key);
}
