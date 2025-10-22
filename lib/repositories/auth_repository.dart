import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const _usersKey = 'auth_users_v1';
  static const _sessionKey = 'auth_session_v1';
  static const _onboardingKey = 'onboarding_complete_v1';

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
}
