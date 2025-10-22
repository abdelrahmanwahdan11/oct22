import 'package:flutter/material.dart';
import 'package:smart_home_control/models/energy_point.dart';
import 'package:smart_home_control/repositories/energy_repository.dart';

class EnergyController extends ChangeNotifier {
  EnergyController(this._repository);

  final EnergyRepository _repository;
  final List<EnergyPoint> _points = [];
  bool _loading = false;
  String _highlight = 'Aug';

  List<EnergyPoint> get points => List.unmodifiable(_points);
  bool get isLoading => _loading;
  String get highlight => _highlight;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    final data = await _repository.fetchMonthly();
    _points
      ..clear()
      ..addAll(data);
    _loading = false;
    notifyListeners();
  }

  void setHighlight(String month) {
    if (_highlight == month) return;
    _highlight = month;
    notifyListeners();
  }
}
