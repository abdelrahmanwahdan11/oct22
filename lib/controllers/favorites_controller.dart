import 'package:flutter/material.dart';

import '../data/models/property.dart';
import '../data/repositories/prefs_repository.dart';
import '../data/repositories/properties_repository.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._prefsRepository, this._propertiesRepository);

  final PrefsRepository _prefsRepository;
  final PropertiesRepository _propertiesRepository;

  Set<String> _favoriteIds = {};
  Map<String, String> _notes = {};
  Set<String> _alertIds = {};

  Set<String> get favoriteIds => _favoriteIds;
  Map<String, String> get notes => _notes;
  Set<String> get alertIds => _alertIds;

  Future<void> load() async {
    _favoriteIds = await _prefsRepository.loadFavorites();
    _notes = await _prefsRepository.loadFavoriteNotes();
    _alertIds = await _prefsRepository.loadSavedAlerts();
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

  String noteFor(String id) => _notes[id] ?? '';

  Future<void> updateNote(String id, String note) async {
    if (note.isEmpty) {
      _notes.remove(id);
    } else {
      _notes[id] = note;
    }
    await _prefsRepository.saveFavoriteNotes(_notes);
    notifyListeners();
  }

  bool hasAlert(String id) => _alertIds.contains(id);

  Future<void> toggleAlert(String id) async {
    if (_alertIds.contains(id)) {
      _alertIds.remove(id);
    } else {
      _alertIds.add(id);
    }
    await _prefsRepository.saveSavedAlerts(_alertIds);
    notifyListeners();
  }

  Future<void> clear() async {
    for (final id in _favoriteIds) {
      _propertiesRepository.updateFavorite(id, false);
    }
    _favoriteIds.clear();
    _notes.clear();
    _alertIds.clear();
    await _prefsRepository.saveFavorites(_favoriteIds);
    await _prefsRepository.saveFavoriteNotes(_notes);
    await _prefsRepository.saveSavedAlerts(_alertIds);
    notifyListeners();
  }
}
