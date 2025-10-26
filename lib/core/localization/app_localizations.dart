import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('ar'), Locale('en')];

  static const _localizedValues = <String, Map<String, String>>{
    'ar': {
      'app_name': 'Luma+ Wellness',
      'for_you': 'مقترح لك',
      'energy': 'الطاقة',
      'heart': 'صحة القلب',
      'stress': 'التوتر',
      'learn_more': 'اعرف المزيد',
      'add_to_plan': 'أضف للخطة',
      'today_plan': 'خطة اليوم',
      'your_progress': 'تقدمك',
      'essentials': 'مكملات أساسية',
      'survey_q': 'كيف كان شعورك هذا الشهر؟',
      'skip': 'تخطي',
      'continue': 'متابعة',
      'start': 'ابدأ',
      'remind_me': 'ذكّرني',
      'take_now': 'خذ الآن',
      'discover': 'استكشف',
      'plan': 'الخطة',
      'profile': 'الملف الشخصي',
      'home': 'الرئيسية',
      'welcome_back': 'مرحباً بعودتك',
      'sign_in': 'تسجيل الدخول',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'login': 'دخول',
      'continue_guest': 'دخول كضيف',
      'create_account': 'إنشاء حساب جديد',
      'feeling_today': 'كيف تشعر اليوم؟',
      'daily_plan': 'خطة اليوم',
      'progress_wheel': 'عجلة التقدم',
      'view_all': 'عرض الكل',
      'plan_empty': 'لم تضف أي مكملات بعد',
      'mark_taken': 'تم تناولها',
      'mark_skipped': 'تم التخطي',
      'mark_pending': 'بانتظار',
      'language': 'اللغة',
      'theme': 'المظهر',
      'dark_mode': 'الوضع الداكن',
      'notifications': 'التذكيرات',
      'settings': 'الإعدادات',
      'survey': 'استبيان',
      'mood': 'المزاج',
      'energy_level': 'مستوى الطاقة',
      'notes': 'ملاحظات',
      'save': 'حفظ',
      'search_hint': 'ابحث عن مكمل/فائدة…',
      'filters': 'التصفية',
      'recommendations': 'التوصيات',
      'best_for': 'أفضل من أجل',
      'benefits': 'الفوائد',
      'ingredients': 'المكونات',
      'dosage': 'الجرعة',
      'schedule': 'الجدول',
      'rating': 'التقييم',
      'loading': 'جاري التحميل…',
      'retry': 'إعادة المحاولة',
      'see_plan': 'عرض الخطة',
    },
    'en': {
      'app_name': 'Luma+ Wellness',
      'for_you': 'For You',
      'energy': 'Energy',
      'heart': 'Heart health',
      'stress': 'Stress',
      'learn_more': 'Learn more',
      'add_to_plan': 'Add to plan',
      'today_plan': "Today's Plan",
      'your_progress': 'Your Progress',
      'essentials': 'Essential Supplements',
      'survey_q': 'How have you been feeling this month?',
      'skip': 'Skip',
      'continue': 'Continue',
      'start': 'Start',
      'remind_me': 'Remind me',
      'take_now': 'Take now',
      'discover': 'Discover',
      'plan': 'Plan',
      'profile': 'Profile',
      'home': 'Home',
      'welcome_back': 'Welcome back',
      'sign_in': 'Sign in',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'continue_guest': 'Continue as guest',
      'create_account': 'Create account',
      'feeling_today': 'How do you feel today?',
      'daily_plan': "Today's Plan",
      'progress_wheel': 'Progress wheel',
      'view_all': 'View all',
      'plan_empty': 'You have no supplements yet',
      'mark_taken': 'Mark taken',
      'mark_skipped': 'Mark skipped',
      'mark_pending': 'Mark pending',
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark mode',
      'notifications': 'Reminders',
      'settings': 'Settings',
      'survey': 'Survey',
      'mood': 'Mood',
      'energy_level': 'Energy level',
      'notes': 'Notes',
      'save': 'Save',
      'search_hint': 'Search supplements/benefits…',
      'filters': 'Filters',
      'recommendations': 'Recommendations',
      'best_for': 'Best for',
      'benefits': 'Benefits',
      'ingredients': 'Ingredients',
      'dosage': 'Dosage',
      'schedule': 'Schedule',
      'rating': 'Rating',
      'loading': 'Loading…',
      'retry': 'Retry',
      'see_plan': 'See plan',
    },
  };

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get languageCode => locale.languageCode;

  String translate(String key) {
    final values = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    return values[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
