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
      'eta_label': 'ETA',
      'more_actions': 'More actions',
      'assign_compartment': 'Assign compartment',
      'reorder': 'Re-order',
      'delete': 'Delete',
      'skip': 'Skip',
      'next': 'Next',
      'get_started': 'Get started',
      'welcome_title1': 'Welcome to Fleet Planner',
      'welcome_body1': 'Orchestrate your truck capacity, stops, and timelines in one cockpit.',
      'welcome_title2': 'Visual load planning',
      'welcome_body2': 'Drag, drop, and balance every compartment with realtime utilization.',
      'welcome_title3': 'Arrive on schedule',
      'welcome_body3': 'Map delays, optimize miles, and keep customers delighted.',
      'sign_in': 'Sign in',
      'sign_up': 'Create account',
      'name': 'Full name',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm password',
      'have_account': 'Already have an account?',
      'need_account': "Need an account?",
      'toggle_password': 'Show password',
      'auth_welcome_back': 'Welcome back, captain',
      'auth_subtitle': 'Use your credentials to continue optimizing routes.',
      'register_title': 'New dispatcher',
      'register_subtitle': 'Create secure access to plan and optimize routes.',
      'invalid_email': 'Enter a valid work email.',
      'invalid_name': 'Add your name to personalize the cockpit.',
      'password_mismatch': 'Passwords do not match.',
      'weak_password': 'Password must contain 8+ chars with uppercase, number, and symbol.',
      'invalid_credentials': 'Email or password is incorrect.',
      'no_account': 'No account found. Create one first.',
      'continue_label': 'Continue',
      'create_account_action': 'Create account',
      'logout': 'Sign out',
      'onboarding_done': 'All set! Let\'s plan.',
      'distribution_hint': 'Drag stops from the dock into a compartment card to balance the load.',
      'search_schedule': 'Search schedule',
      'status_awaiting': 'Awaiting',
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
      'eta_label': 'الوصول المتوقع',
      'more_actions': 'إجراءات إضافية',
      'assign_compartment': 'إسناد إلى مقصورة',
      'reorder': 'إعادة ترتيب',
      'delete': 'حذف',
      'skip': 'تخطي',
      'next': 'التالي',
      'get_started': 'لنبدأ',
      'welcome_title1': 'مرحبًا بك في مخطط الأسطول',
      'welcome_body1': 'أدِر سعة الشاحنة والتوقفات والجداول الزمنية من لوحة واحدة.',
      'welcome_title2': 'تخطيط حمولة بصري',
      'welcome_body2': 'اسحب وأفلت ووازن كل مقصورة مع مراقبة فورية لنسب الاستغلال.',
      'welcome_title3': 'الوصول في الموعد',
      'welcome_body3': 'تتبع التأخيرات، حسّن الأميال، وأبقِ عملاءك سعداء.',
      'sign_in': 'تسجيل الدخول',
      'sign_up': 'إنشاء حساب',
      'name': 'الاسم الكامل',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'have_account': 'لديك حساب بالفعل؟',
      'need_account': 'تحتاج حسابًا؟',
      'toggle_password': 'إظهار كلمة المرور',
      'auth_welcome_back': 'مرحبًا بعودتك يا قائد',
      'auth_subtitle': 'استخدم بيانات اعتمادك لمتابعة تحسين المسارات.',
      'register_title': 'منسق جديد',
      'register_subtitle': 'أنشئ وصولًا آمنًا للتخطيط وتحسين المسارات.',
      'invalid_email': 'أدخل بريدًا إلكترونيًا صالحًا.',
      'invalid_name': 'أضف اسمك لتخصيص اللوحة.',
      'password_mismatch': 'كلمتا المرور غير متطابقتين.',
      'weak_password': 'يجب أن تحتوي كلمة المرور على 8 أحرف مع حرف كبير ورقم ورمز.',
      'invalid_credentials': 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
      'no_account': 'لم يتم العثور على حساب. أنشئ واحدًا أولاً.',
      'continue_label': 'متابعة',
      'create_account_action': 'إنشاء الحساب',
      'logout': 'تسجيل الخروج',
      'onboarding_done': 'كل شيء جاهز! لنخطط.',
      'distribution_hint': 'اسحب نقاط التوقف من القائمة السفلية وأسقطها داخل بطاقة المقصورة لتوزيع الحمولة.',
      'search_schedule': 'ابحث في الجدول',
      'status_awaiting': 'بانتظار التنفيذ',
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
