import 'dart:async';

import 'package:flutter/material.dart';

import '../data/models/filters.dart';
import '../data/models/property.dart';
import '../data/repositories/properties_repository.dart';
import 'favorites_controller.dart';
import 'filters_controller.dart';

class PropertiesController extends ChangeNotifier {
  PropertiesController(
    this._propertiesRepository,
    this._filtersController,
    this._favoritesController,
  ) {
    _filtersController.addListener(_handleFiltersChanged);
    _favoritesController.addListener(_handleFavoritesChanged);
  }

  final PropertiesRepository _propertiesRepository;
  final FiltersController _filtersController;
  final FavoritesController _favoritesController;

  final ScrollController scrollController = ScrollController();

  List<Property> _featured = [];
  List<Property> _explore = [];
  List<Property> _feed = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  Timer? _debounce;
  String _searchQuery = '';

  List<Property> get featured => _featured;
  List<Property> get explore => _explore;
  List<Property> get feed => _feed;
  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;

  Filters get filters => _filtersController.filters;

  Property? findById(String id) => _propertiesRepository.findById(id);

  Future<void> loadInitial() async {
    if (_loading) return;
    _loading = true;
    notifyListeners();
    await Future.wait([
      _loadFeatured(),
      _loadExplore(),
      _loadFeed(reset: true),
    ]);
    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    await _loadFeed(reset: true);
    await _loadFeatured();
    await _loadExplore();
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _loadingMore) return;
    _loadingMore = true;
    notifyListeners();
    _page += 1;
    final pageResult = await _propertiesRepository.fetchProperties(
      filters: filters,
      search: _searchQuery,
      page: _page,
    );
    final mapped = _mapFavorites(pageResult.items);
    _feed = [..._feed, ...mapped];
    _hasMore = pageResult.hasMore;
    _loadingMore = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      _page = 1;
      _hasMore = true;
      await _loadFeed(reset: true);
      notifyListeners();
    });
  }

  Future<void> _loadFeatured() async {
    final items = await _propertiesRepository.fetchFeatured(filters: filters);
    _featured = _mapFavorites(items);
  }

  Future<void> _loadExplore() async {
    final items = await _propertiesRepository.fetchExplore(filters: filters);
    _explore = _mapFavorites(items);
  }

  Future<void> _loadFeed({required bool reset}) async {
    if (reset) {
      _feed = [];
      _page = 1;
      _hasMore = true;
    }
    final result = await _propertiesRepository.fetchProperties(
      filters: filters,
      search: _searchQuery,
      page: _page,
    );
    final mapped = _mapFavorites(result.items);
    _feed = reset ? mapped : [..._feed, ...mapped];
    _hasMore = result.hasMore;
  }

  List<Property> _mapFavorites(List<Property> items) {
    return items
        .map(
          (property) => property.copyWith(
            favorite: _favoritesController.isFavorite(property.id),
          ),
        )
        .toList();
  }

  Future<void> toggleFavorite(Property property) {
    return _favoritesController.toggle(property.id);
  }

  void _handleFiltersChanged() {
    refresh();
  }

  void _handleFavoritesChanged() {
    _featured = _mapFavorites(_featured);
    _explore = _mapFavorites(_explore);
    _feed = _mapFavorites(_feed);
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    scrollController.dispose();
    _filtersController.removeListener(_handleFiltersChanged);
    _favoritesController.removeListener(_handleFavoritesChanged);
    super.dispose();
  }
}
