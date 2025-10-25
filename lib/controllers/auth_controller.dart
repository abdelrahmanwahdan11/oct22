import 'package:flutter/material.dart';

class AuthUser {
  const AuthUser({required this.id, required this.name});

  final String id;
  final String name;
}

class AuthController extends ChangeNotifier {
  AuthUser? _user;
  bool _loading = false;

  AuthUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _loading;

  Future<void> login({required String email, required String password}) async {
    _setLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _user = AuthUser(id: 'user_${email.hashCode}', name: email.split('@').first);
    _setLoading(false);
  }

  Future<void> continueAsGuest() async {
    _user = const AuthUser(id: 'guest', name: 'Guest');
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _user = AuthUser(id: 'user_${email.hashCode}', name: name);
    _setLoading(false);
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
