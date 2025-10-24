import 'package:flutter/material.dart';

import '../data/models/user.dart';

class AuthController extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  void login({required String email, required String password}) {
    _user = User(
      id: email,
      name: email.split('@').first,
      email: email,
      avatar: 'https://i.pravatar.cc/150?u=$email',
    );
    notifyListeners();
  }

  void register({
    required String name,
    required String email,
    required String phone,
  }) {
    _user = User(
      id: email,
      name: name,
      email: email,
      phone: phone,
      avatar: 'https://i.pravatar.cc/150?u=$email',
    );
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
