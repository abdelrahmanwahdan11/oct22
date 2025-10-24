import 'package:flutter/material.dart';

import '../data/models/filters.dart';
import '../data/repositories/prefs_repository.dart';

class FiltersController extends ChangeNotifier {
  FiltersController(this._prefsRepository);

  final PrefsRepository _prefsRepository;

  Filters _filters = Filters.empty();
  Filters? _savedFilter;

  Filters get filters => _filters;
  Filters? get savedFilter => _savedFilter;

  Future<void> load() async {
    final saved = await _prefsRepository.loadSavedFilter();
    if (saved != null) {
      _savedFilter = Filters.fromJson(saved);
      _filters = _savedFilter!;
    }
    notifyListeners();
  }

  void update(Filters filters) {
    _filters = filters;
    notifyListeners();
  }

  void setQuery(String? query) {
    _filters = _filters.copyWith(query: query);
    notifyListeners();
  }

  Future<void> saveCurrent() async {
    await _prefsRepository.saveFilter(_filters.toJson());
    _savedFilter = _filters;
    notifyListeners();
  }

  void reset() {
    _filters = Filters.empty();
    notifyListeners();
  }
}
