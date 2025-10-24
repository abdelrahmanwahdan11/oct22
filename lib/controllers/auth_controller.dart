import 'package:flutter/material.dart';

import '../data/models/user.dart';
import '../data/repositories/prefs_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._prefsRepository);

  final PrefsRepository _prefsRepository;

  User? _user;
  bool _rememberMe = false;
  String? _rememberedEmail;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get rememberMe => _rememberMe;
  String get rememberedEmail => _rememberedEmail ?? '';

  Future<void> load() async {
    _rememberMe = await _prefsRepository.loadRememberMe();
    _rememberedEmail = await _prefsRepository.loadRememberedEmail();
    notifyListeners();
  }

  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    await _prefsRepository.saveRememberMe(value);
    if (!value) {
      _rememberedEmail = null;
      await _prefsRepository.saveRememberedEmail(null);
    }
    notifyListeners();
  }

  Future<void> _persistRememberedEmail(String email) async {
    if (_rememberMe) {
      _rememberedEmail = email;
      await _prefsRepository.saveRememberedEmail(email);
    } else {
      _rememberedEmail = null;
      await _prefsRepository.saveRememberedEmail(null);
    }
  }

  Future<void> login({required String email, required String password}) async {
    _user = User(
      id: email,
      name: email.split('@').first,
      email: email,
      avatar: 'https://i.pravatar.cc/150?u=$email',
    );
    await _persistRememberedEmail(email);
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
  }) async {
    _user = User(
      id: email,
      name: name,
      email: email,
      phone: phone,
      avatar: 'https://i.pravatar.cc/150?u=$email',
    );
    await _persistRememberedEmail(email);
    notifyListeners();
  }

  void continueAsGuest() {
    _user = const User(
      id: 'guest',
      name: 'Guest',
      email: 'guest@realestate.plus',
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
