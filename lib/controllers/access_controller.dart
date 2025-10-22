import 'package:flutter/material.dart';
import 'package:smart_home_control/data/mock_data.dart';
import 'package:smart_home_control/models/access_rule.dart';
import 'package:smart_home_control/repositories/settings_repository.dart';

class AccessController extends ChangeNotifier {
  AccessController(this._settingsRepository);

  final SettingsRepository _settingsRepository;
  final List<AccessRule> _rules = [];
  bool _loading = false;

  List<AccessRule> get rules => List.unmodifiable(_rules);
  bool get isLoading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    final loaded = await _settingsRepository.loadAccessRules(MockData.accessRules);
    _rules
      ..clear()
      ..addAll(loaded);
    _loading = false;
    notifyListeners();
  }

  Future<void> toggle(String id, bool value) async {
    final index = _rules.indexWhere((rule) => rule.id == id);
    if (index == -1) return;
    _rules[index] = _rules[index].copyWith(enabled: value);
    await _settingsRepository.saveAccessRules(_rules);
    notifyListeners();
  }
}
