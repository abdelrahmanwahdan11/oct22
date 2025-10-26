import 'package:flutter/foundation.dart';

import '../data/models/membership_pass.dart';
import '../data/repositories/pass_repository.dart';

class PassController extends ChangeNotifier {
  PassController(this._repository);

  final PassRepository _repository;

  MembershipPass? _primary;
  bool _isLoading = false;

  MembershipPass? get pass => _primary;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    _primary = await _repository.fetchPrimaryPass();
    _isLoading = false;
    notifyListeners();
  }
}
