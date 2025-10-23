import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const _localizedValues = {
    'en': {
      'planning': 'Planning',
      'distribution': 'Distribution',
      'statistics': 'Statistics',
      'stops': 'Stops',
      'optimizer': 'Optimizer',
      'sort_weight': 'Sort by weight',
      'sort_pallets': 'Sort by pallets',
      'auto_assign': 'Auto assign',
      'no_stops': 'No stops yet',
      'open_cockpit': 'Open Cockpit',
      'arrival_at': 'Arrival at',
      'delay': 'Delay',
      'drag_more': 'Drag up for more details',
      'settings': 'Settings',
      'dark_mode': 'Dark mode',
      'units': 'Units',
      'locale': 'Locale',
      'imperial': 'mi/lb',
      'metric': 'km/kg',
      'timeline_title': 'Timeline (Cockpit)',
      'utilization': 'Utilization',
      'weight': 'Weight',
      'pallets': 'Pallets',
      'stops_count': 'Stops',
      'extra_orders': 'Extra orders available for this route.',
      'optimization_plan': 'Optimization plan',
      'distance': 'Distance',
      'weight_total': 'Weight',
      'mi': 'mi',
      'lb': 'lb',
      'selected': 'Selected',
    },
    'ar': {
      'planning': 'التخطيط',
      'distribution': 'التوزيع',
      'statistics': 'الإحصائيات',
      'stops': 'التوقفات',
      'optimizer': 'المحسِّن',
      'sort_weight': 'ترتيب حسب الوزن',
      'sort_pallets': 'ترتيب حسب المنصات',
      'auto_assign': 'إسناد تلقائي',
      'no_stops': 'لا توجد توقفات',
      'open_cockpit': 'عرض لوحة التحكم',
      'arrival_at': 'وقت الوصول',
      'delay': 'تأخير',
      'drag_more': 'اسحب للأعلى لمزيد من التفاصيل',
      'settings': 'الإعدادات',
      'dark_mode': 'الوضع الداكن',
      'units': 'الوحدات',
      'locale': 'اللغة',
      'imperial': 'ميل/رطل',
      'metric': 'كم/كغ',
      'timeline_title': 'المخطط الزمني (قمرة القيادة)',
      'utilization': 'نسب الاستغلال',
      'weight': 'الوزن',
      'pallets': 'المنصات',
      'stops_count': 'التوقفات',
      'extra_orders': 'طلبات إضافية متاحة لهذه الرحلة.',
      'optimization_plan': 'خطة التحسين',
      'distance': 'المسافة',
      'weight_total': 'الحمولة',
      'mi': 'ميل',
      'lb': 'رطل',
      'selected': 'محدد',
    },
  };

  static const delegate = _AppLocalizationsDelegate();

  String t(String key) {
    final languageCode = locale.languageCode;
    final values = _localizedValues[languageCode] ?? _localizedValues['en']!;
    return values[key] ?? _localizedValues['en']![key] ?? key;
  }

  bool get isRtl => locale.languageCode == 'ar';

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
