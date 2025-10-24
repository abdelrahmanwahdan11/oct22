import 'package:flutter/material.dart';

import '../data/models/property.dart';
import '../data/repositories/prefs_repository.dart';
import '../data/repositories/properties_repository.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._prefsRepository, this._propertiesRepository);

  final PrefsRepository _prefsRepository;
  final PropertiesRepository _propertiesRepository;

  Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  Future<void> load() async {
    _favoriteIds = await _prefsRepository.loadFavorites();
    for (final id in _favoriteIds) {
      _propertiesRepository.updateFavorite(id, true);
    }
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> toggle(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
      _propertiesRepository.updateFavorite(id, false);
      await _prefsRepository.saveFavorites(_favoriteIds);
      notifyListeners();
      return;
    }
    _favoriteIds.add(id);
    _propertiesRepository.updateFavorite(id, true);
    await _prefsRepository.saveFavorites(_favoriteIds);
    notifyListeners();
  }

  List<Property> favoritesList() {
    return _favoriteIds
        .map(_propertiesRepository.findById)
        .whereType<Property>()
        .toList();
  }

  Future<void> clear() async {
    _favoriteIds.clear();
    await _prefsRepository.saveFavorites(_favoriteIds);
    notifyListeners();
  }
}
