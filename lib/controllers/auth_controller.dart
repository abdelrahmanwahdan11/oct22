import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/repositories/auth_repository.dart';

enum AuthStep { loading, onboarding, unauthenticated, authenticated }
enum AuthScreen { signIn, signUp }

class AuthController extends ChangeNotifier {
  AuthController(this._repository, this.localization);

  final AuthRepository _repository;
  final AppLocalizations localization;

  AuthStep _step = AuthStep.loading;
  AuthScreen _screen = AuthScreen.signIn;
  String? _displayName;
  String? _email;
  bool _busy = false;
  String? _errorKey;

  AuthStep get step => _step;
  AuthScreen get screen => _screen;
  bool get isBusy => _busy;
  String? get errorKey => _errorKey;
  String get displayName => _displayName ?? 'Jhon Snow';
  String? get email => _email;

  Future<void> initialize() async {
    final completed = await _repository.isOnboardingComplete();
    if (!completed) {
      _step = AuthStep.onboarding;
      notifyListeners();
      return;
    }

    final session = await _repository.currentSession();
    if (session == null) {
      _step = AuthStep.unauthenticated;
      notifyListeners();
      return;
    }

    final user = await _repository.findUser(session);
    if (user == null) {
      await _repository.clearSession();
      _step = AuthStep.unauthenticated;
    } else {
      _displayName = user['name'] as String? ?? 'User';
      _email = user['email'] as String?;
      _step = AuthStep.authenticated;
    }
    notifyListeners();
  }

  void setScreen(AuthScreen screen) {
    if (_screen == screen) return;
    _screen = screen;
    _errorKey = null;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _repository.setOnboardingComplete();
    _step = AuthStep.unauthenticated;
    _screen = AuthScreen.signUp;
    _errorKey = null;
    notifyListeners();
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setBusy(true);
    final user = await _repository.findUser(email);
    if (user == null) {
      _setError('auth_error_invalid');
      _setBusy(false);
      return false;
    }
    final stored = user['password'] as String?;
    if (stored == null || stored != _hash(password)) {
      _setError('auth_error_invalid');
      _setBusy(false);
      return false;
    }
    _displayName = user['name'] as String? ?? 'User';
    _email = user['email'] as String? ?? email;
    await _repository.persistSession(email);
    _errorKey = null;
    _step = AuthStep.authenticated;
    _setBusy(false);
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      _setError('auth_error_passwords');
      notifyListeners();
      return false;
    }
    if (password.length < 6) {
      _setError('auth_error_weak_password');
      notifyListeners();
      return false;
    }
    _setBusy(true);
    final existing = await _repository.findUser(email);
    if (existing != null) {
      _setError('auth_error_exists');
      _setBusy(false);
      return false;
    }
    final payload = {
      'name': name,
      'email': email,
      'password': _hash(password),
    };
    await _repository.saveUser(payload);
    await _repository.persistSession(email);
    _displayName = name;
    _email = email;
    _errorKey = null;
    _step = AuthStep.authenticated;
    _setBusy(false);
    return true;
  }

  Future<void> signOut() async {
    await _repository.clearSession();
    _step = AuthStep.unauthenticated;
    _screen = AuthScreen.signIn;
    _email = null;
    notifyListeners();
  }

  void _setBusy(bool value) {
    if (_busy == value) return;
    _busy = value;
    notifyListeners();
  }

  void _setError(String key) {
    _errorKey = key;
  }

  String _hash(String value) {
    final bytes = utf8.encode(value);
    return base64Encode(bytes);
  }
}
