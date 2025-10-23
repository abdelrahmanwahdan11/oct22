import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const _emailKey = 'auth_email';
  static const _passwordKey = 'auth_password';
  static const _displayNameKey = 'auth_display_name';
  static const _onboardingKey = 'completed_onboarding';
  static const _loggedInKey = 'is_logged_in';

  Future<AuthState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    final password = prefs.getString(_passwordKey);
    final displayName = prefs.getString(_displayNameKey);
    final completedOnboarding = prefs.getBool(_onboardingKey) ?? false;
    final isLoggedIn = prefs.getBool(_loggedInKey) ?? false;
    return AuthState(
      email: email,
      password: password,
      displayName: displayName,
      completedOnboarding: completedOnboarding,
      isLoggedIn: isLoggedIn,
    );
  }

  Future<void> saveCredentials({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
    await prefs.setString(_displayNameKey, displayName);
  }

  Future<void> setOnboardingComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, value);
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }
}

class AuthState {
  const AuthState({
    required this.email,
    required this.password,
    required this.displayName,
    required this.completedOnboarding,
    required this.isLoggedIn,
  });

  final String? email;
  final String? password;
  final String? displayName;
  final bool completedOnboarding;
  final bool isLoggedIn;

  bool get hasAccount => email != null && password != null;
}
