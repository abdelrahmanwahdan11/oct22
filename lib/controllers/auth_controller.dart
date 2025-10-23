import 'dart:async';

import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  String? _email;
  String? _password;
  String? _displayName;
  bool _completedOnboarding = false;
  bool _isAuthenticated = false;
  bool _loading = true;
  String? _errorMessage;

  bool get loading => _loading;
  bool get completedOnboarding => _completedOnboarding;
  bool get isAuthenticated => _isAuthenticated;
  String? get email => _email;
  String? get displayName => _displayName;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    final state = await _repository.load();
    _email = state.email;
    _password = state.password;
    _displayName = state.displayName;
    _completedOnboarding = state.completedOnboarding;
    _isAuthenticated = state.isLoggedIn && state.email != null;
    _loading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _completedOnboarding = true;
    await _repository.setOnboardingComplete(true);
    notifyListeners();
  }

  Future<AuthResult> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
  }) async {
    final validation = _validateCredentials(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      name: name,
    );
    if (validation != null) {
      _errorMessage = validation;
      notifyListeners();
      return AuthResult(success: false, message: validation);
    }

    await _repository.saveCredentials(
      email: email,
      password: password,
      displayName: name,
    );
    await _repository.setLoggedIn(true);
    if (!_completedOnboarding) {
      _completedOnboarding = true;
      await _repository.setOnboardingComplete(true);
    }
    _email = email;
    _password = password;
    _displayName = name;
    _isAuthenticated = true;
    _errorMessage = null;
    notifyListeners();
    return const AuthResult(success: true);
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    if (_email == null || _password == null) {
      _errorMessage = 'no_account';
      notifyListeners();
      return const AuthResult(success: false, message: 'no_account');
    }
    if (email.trim().toLowerCase() != _email!.toLowerCase() || password != _password) {
      _errorMessage = 'invalid_credentials';
      notifyListeners();
      return const AuthResult(success: false, message: 'invalid_credentials');
    }
    await _repository.setLoggedIn(true);
    _isAuthenticated = true;
    _errorMessage = null;
    notifyListeners();
    return const AuthResult(success: true);
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    _errorMessage = null;
    await _repository.setLoggedIn(false);
    notifyListeners();
  }

  String? _validateCredentials({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
  }) {
    final emailRegex = RegExp(r'^([\w\-\.]+)@([\w\-]+)\.([A-Za-z]{2,})$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'invalid_email';
    }
    if (password != confirmPassword) {
      return 'password_mismatch';
    }
    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password) ||
        !RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'weak_password';
    }
    if (name.trim().isEmpty) {
      return 'invalid_name';
    }
    return null;
  }
}

class AuthResult {
  const AuthResult({required this.success, this.message});

  final bool success;
  final String? message;
}
