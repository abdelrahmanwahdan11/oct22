import 'package:flutter/material.dart';

import '../data/models/supplement.dart';
import '../data/repositories/prefs_repository.dart';
import '../data/repositories/supplements_repository.dart';

class SupplementsController extends ChangeNotifier {
  SupplementsController(this._repository, this._prefsRepository);

  final SupplementsRepository _repository;
  final PrefsRepository _prefsRepository;

  final List<Supplement> _items = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasMore = true;
  int _currentPage = 0;
  List<String> _selectedTags = [];
  String _query = '';

  List<Supplement> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get hasMore => _hasMore;
  List<String> get selectedTags => _selectedTags;
  String get query => _query;

  Future<void> init() async {
    await _prefsRepository.init();
    _selectedTags = _prefsRepository.getFilters();
    await refresh();
  }

  Future<void> refresh() async {
    _isRefreshing = true;
    _currentPage = 0;
    _items.clear();
    _hasMore = true;
    notifyListeners();
    await _load();
    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _currentPage++;
    await _load();
  }

  Future<void> search(String value) async {
    _query = value;
    await refresh();
  }

  Future<void> toggleTag(String tag) async {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    await _prefsRepository.saveFilters(_selectedTags);
    await refresh();
  }

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    final result = await _repository.fetchSupplements(
      page: _currentPage,
      selectedTags: _selectedTags,
      query: _query,
    );
    if (_currentPage == 0) {
      _items
        ..clear()
        ..addAll(result);
    } else {
      _items.addAll(result);
    }
    if (result.length < _repository.pageSize) {
      _hasMore = false;
    }
    _isLoading = false;
    notifyListeners();
  }
}
