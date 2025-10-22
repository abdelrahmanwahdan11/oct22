import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const _usersKey = 'auth_users_v1';
  static const _sessionKey = 'auth_session_v1';
  static const _onboardingKey = 'onboarding_complete_v1';
  static const _rememberKey = 'auth_remember_me_v1';
  static const _lastEmailKey = 'auth_last_email_v1';
  static const _resetRequestKey = 'auth_reset_requests_v1';

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<Map<String, dynamic>?> findUser(String email) async {
    final users = await _loadUsers();
    try {
      return users.firstWhere(
        (user) => (user['email'] as String).toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final users = await _loadUsers();
    final index = users.indexWhere(
      (item) => (item['email'] as String).toLowerCase() ==
          (user['email'] as String).toLowerCase(),
    );
    if (index >= 0) {
      users[index] = user;
    } else {
      users.add(user);
    }
    await _saveUsers(users);
  }

  Future<void> persistSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, email);
  }

  Future<String?> currentSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<void> saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberKey, value);
  }

  Future<bool> loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberKey) ?? false;
  }

  Future<void> saveLastEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastEmailKey, email);
  }

  Future<String?> loadLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastEmailKey);
  }

  Future<void> clearLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastEmailKey);
  }

  Future<Map<String, dynamic>> _loadResetRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_resetRequestKey);
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> _saveResetRequests(Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_resetRequestKey, jsonEncode(map));
  }

  Future<bool> requestPasswordReset(String email) async {
    final user = await findUser(email);
    if (user == null) return false;
    final map = await _loadResetRequests();
    map[email] = DateTime.now().toIso8601String();
    await _saveResetRequests(map);
    return true;
  }

  Future<DateTime?> lastResetFor(String email) async {
    final map = await _loadResetRequests();
    final value = map[email];
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
