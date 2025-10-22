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
  String t(String key) => _strings[key] ?? key;

  static const _localizedValues = {
    'en': {
      'rooms': 'My Rooms',
      'devices': 'My Devices',
      'energy_consumption': 'Energy Consumption',
      'search_device': 'Search Device',
      'add_device': 'Add Device',
      'add_room': 'Add Room',
      'energy_analysis': 'Energy Analysis',
      'nav_home': 'Home',
      'nav_devices': 'Devices',
      'nav_rooms': 'Rooms',
      'nav_more': 'More',
      'greeting': 'Hello, {name}',
      'greeting_subtitle': 'Set up devices. Take control.',
      'onboarding_title_1': 'Effortless Control',
      'onboarding_title_2': 'Stay Informed Anywhere',
      'onboarding_title_3': 'Automate Comfort',
      'onboarding_desc_1': 'Manage every smart device in one elegant dashboard designed for speed.',
      'onboarding_desc_2': 'Monitor rooms, cameras, and energy trends no matter where you are.',
      'onboarding_desc_3': 'Create schedules and modes that keep your family comfortable automatically.',
      'next': 'Next',
      'skip': 'Skip',
      'get_started': 'Get Started',
      'sign_in_title': 'Welcome Back',
      'sign_up_title': 'Create Account',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'sign_in_action': 'Sign In',
      'sign_up_action': 'Sign Up',
      'no_account': "Don't have an account?",
      'have_account': 'Already have an account?',
      'create_now': 'Create one',
      'login_now': 'Log in',
      'remember_me': 'Remember me',
      'auth_error_invalid': 'Incorrect email or password.',
      'auth_error_exists': 'An account with this email already exists.',
      'auth_error_passwords': 'Passwords do not match.',
      'auth_error_weak_password': 'Password must be at least 6 characters.',
      'theme': 'Theme',
      'theme_light': 'Light',
      'theme_dark': 'Dark',
      'theme_system': 'System',
      'language': 'Language',
      'choose_language': 'Choose language',
      'logout': 'Sign Out',
      'more_title': 'Profile & Settings',
      'user_access': 'User Access',
      'open': 'Open',
      'add_device_catalog': 'Browse catalog',
      'select_room': 'Select Room',
      'catalog_header': 'Smart Device Catalog',
      'catalog_subtitle': 'Pick a device to add to your home',
      'cancel': 'Cancel',
      'save': 'Save',
      'name_required': 'Name is required',
      'email_required': 'Email is required',
      'password_required': 'Password is required',
      'email_invalid': 'Please enter a valid email address',
      'welcome_back': 'Welcome back',
      'sign_out_confirm': 'Are you sure you want to sign out?',
      'device_added': '{name} added successfully',
    },
    'ar': {
      'rooms': 'غرفي',
      'devices': 'أجهزتي',
      'energy_consumption': 'استهلاك الطاقة',
      'search_device': 'ابحث عن جهاز',
      'add_device': 'أضف جهازًا',
      'add_room': 'أضف غرفة',
      'energy_analysis': 'تحليل الطاقة',
      'nav_home': 'الرئيسية',
      'nav_devices': 'الأجهزة',
      'nav_rooms': 'الغرف',
      'nav_more': 'المزيد',
      'greeting': 'مرحبًا، {name}',
      'greeting_subtitle': 'قم بضبط الأجهزة وتحكم فيها بسهولة.',
      'onboarding_title_1': 'تحكم بلا مجهود',
      'onboarding_title_2': 'ابقَ على اطلاع في أي مكان',
      'onboarding_title_3': 'راحة مؤتمتة',
      'onboarding_desc_1': 'أدر كل أجهزتك الذكية من لوحة واحدة أنيقة وسريعة.',
      'onboarding_desc_2': 'راقب الغرف والكاميرات واستهلاك الطاقة أينما كنت.',
      'onboarding_desc_3': 'أنشئ جداول وأوضاعًا تبقي عائلتك مرتاحة تلقائيًا.',
      'next': 'التالي',
      'skip': 'تخطي',
      'get_started': 'ابدأ الآن',
      'sign_in_title': 'مرحبًا بعودتك',
      'sign_up_title': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'full_name': 'الاسم الكامل',
      'sign_in_action': 'تسجيل الدخول',
      'sign_up_action': 'إنشاء حساب',
      'no_account': 'لا تملك حسابًا؟',
      'have_account': 'لديك حساب بالفعل؟',
      'create_now': 'أنشئ واحدًا',
      'login_now': 'سجّل الدخول',
      'remember_me': 'تذكرني',
      'auth_error_invalid': 'البريد أو كلمة المرور غير صحيحة.',
      'auth_error_exists': 'هناك حساب مسجل بهذا البريد الإلكتروني.',
      'auth_error_passwords': 'كلمتا المرور غير متطابقتين.',
      'auth_error_weak_password': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل.',
      'theme': 'السمة',
      'theme_light': 'فاتحة',
      'theme_dark': 'داكنة',
      'theme_system': 'حسب النظام',
      'language': 'اللغة',
      'choose_language': 'اختر اللغة',
      'logout': 'تسجيل الخروج',
      'more_title': 'الملف والإعدادات',
      'user_access': 'صلاحيات المستخدم',
      'open': 'فتح',
      'add_device_catalog': 'تصفح الكتالوج',
      'select_room': 'اختر الغرفة',
      'catalog_header': 'كتالوج الأجهزة الذكية',
      'catalog_subtitle': 'اختر جهازًا لإضافته إلى منزلك',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'name_required': 'الاسم مطلوب',
      'email_required': 'البريد مطلوب',
      'password_required': 'كلمة المرور مطلوبة',
      'email_invalid': 'يرجى إدخال بريد إلكتروني صالح',
      'welcome_back': 'مرحبًا مجددًا',
      'sign_out_confirm': 'هل تريد تسجيل الخروج؟',
      'device_added': 'تمت إضافة {name} بنجاح',
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
