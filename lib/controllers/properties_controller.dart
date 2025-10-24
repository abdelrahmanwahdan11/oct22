import 'dart:async';

import 'package:flutter/material.dart';

import '../data/mock/app_content.dart';
import '../data/models/filters.dart';
import '../data/models/property.dart';
import '../data/repositories/prefs_repository.dart';
import '../data/repositories/properties_repository.dart';
import 'favorites_controller.dart';
import 'filters_controller.dart';

class PropertiesController extends ChangeNotifier {
  PropertiesController(
    this._propertiesRepository,
    this._filtersController,
    this._favoritesController,
    this._prefsRepository,
  ) {
    _filtersController.addListener(_handleFiltersChanged);
    _favoritesController.addListener(_handleFavoritesChanged);
    _seedFallbacks();
    _rebuildRecommendations();
  }

  final PropertiesRepository _propertiesRepository;
  final FiltersController _filtersController;
  final FavoritesController _favoritesController;
  final PrefsRepository _prefsRepository;

  List<Property> _featured = [];
  List<Property> _explore = [];
  List<Property> _feed = [];
  List<Property> _recommended = [];
  List<Property> _recentlyViewed = [];
  List<String> _recentSearches = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  Timer? _debounce;
  String _searchQuery = '';
  bool _initialized = false;
  String? _activeLifestyle;
  Set<String> _compareIds = {};

  List<Property> get featured => _featured;
  List<Property> get explore => _explore;
  List<Property> get feed => _feed;
  List<Property> get recommended => _recommended;
  List<Property> get recentlyViewed => _recentlyViewed;
  List<String> get recentSearches => _recentSearches;
  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;
  bool get initialized => _initialized;
  String? get activeLifestyle => _activeLifestyle;
  Set<String> get compareIds => _compareIds;

  Filters get filters => _filtersController.filters;

  Property? findById(String id) => _propertiesRepository.findById(id);

  Future<void> ensureLoaded() async {
    if (_initialized) return;
    await loadInitial();
  }

  Future<void> loadInitial() async {
    if (_loading || _initialized) return;
    _loading = true;
    notifyListeners();
    try {
      await Future.wait([
        _loadFeatured(),
        _loadExplore(),
        _loadFeed(reset: true),
      ]);
      await _loadRecentSearches();
      await _loadRecentViews();
      await _loadCompare();
    } catch (_) {
      _seedFallbacks();
    } finally {
      _rebuildRecommendations();
      _initialized = true;
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    _loading = true;
    notifyListeners();
    try {
      await _loadFeed(reset: true);
      await _loadFeatured();
      await _loadExplore();
    } catch (_) {
      _seedFallbacks();
    } finally {
      _rebuildRecommendations();
      _loading = false;
      notifyListeners();
    }
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

  void setSearchQuery(String query, {bool immediate = false}) {
    final normalized = query.trim();
    final changed = _searchQuery != normalized;
    if (!immediate && !changed) {
      return;
    }
    _searchQuery = normalized;
    _debounce?.cancel();
    if (immediate) {
      _runSearch(recordRecent: changed, notifyStart: true);
    } else {
      _loading = true;
      notifyListeners();
      _debounce = Timer(const Duration(milliseconds: 350), () {
        _runSearch(recordRecent: changed, notifyStart: false);
      });
    }
  }

  void applyLifestyle(String lifestyleId) {
    final preset = AppContent.lifestylePresets
        .firstWhere((item) => item['id'] == lifestyleId, orElse: () => {});
    if (preset.isEmpty) return;
    _activeLifestyle = lifestyleId;
    final types = (preset['types'] as List?)?.cast<String>() ?? const [];
    final status = preset['status'] as String?;
    final city = preset['city'] as String?;
    final minBeds = preset['minBeds'] as int?;
    final sort = preset['sort'] as String?;
    final updated = filters.copyWith(
      status: status,
      types: types,
      city: city,
      minBeds: minBeds,
      sort: sort,
    );
    _filtersController.update(updated);
    refresh();
  }

  void clearLifestyle() {
    _activeLifestyle = null;
    _filtersController.reset();
  }

  Future<void> registerSearch(String query, {bool notify = true}) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return;
    await _prefsRepository.addRecentSearch(normalized);
    await _loadRecentSearches();
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> _runSearch({required bool recordRecent, required bool notifyStart}) async {
    if (notifyStart) {
      _loading = true;
      notifyListeners();
    }
    try {
      _page = 1;
      _hasMore = true;
      await _loadFeed(reset: true);
      if (recordRecent && _searchQuery.length >= 3) {
        await registerSearch(_searchQuery, notify: false);
      }
    } catch (_) {
      _seedFallbacks();
    } finally {
      _rebuildRecommendations();
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> registerView(String id) async {
    await _prefsRepository.addRecentView(id);
    await _loadRecentViews();
    _rebuildRecommendations();
    notifyListeners();
  }

  List<Property> similarTo(String id) {
    return _propertiesRepository.similarProperties(id);
  }

  bool isInCompare(String id) => _compareIds.contains(id);

  List<Property> compareList() =>
      _compareIds.map(_propertiesRepository.findById).whereType<Property>().toList();

  Future<void> toggleCompare(String id) async {
    if (_compareIds.contains(id)) {
      _compareIds.remove(id);
    } else {
      _compareIds.add(id);
    }
    await _prefsRepository.saveCompare(_compareIds);
    notifyListeners();
  }

  Future<Property> submitProperty({
    required String title,
    required String type,
    required String status,
    required num price,
    required String currency,
    required String city,
    required String address,
    required double lat,
    required double lng,
    required int beds,
    required int baths,
    required int areaM2,
    required List<String> images,
    required List<String> features,
    String? description,
  }) async {
    final property = Property(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      type: type,
      status: status,
      price: price,
      currency: currency,
      city: city,
      address: address,
      lat: lat,
      lng: lng,
      beds: beds,
      baths: baths,
      areaM2: areaM2,
      images: images,
      features: features,
      isFeatured: false,
      agentId: 'custom',
      postedAt: DateTime.now(),
      favorite: false,
      description: description,
    );
    final saved = await _propertiesRepository.submitProperty(property);
    _feed = [saved, ..._feed];
    _explore = [saved, ..._explore];
    _featured = [saved, ..._featured];
    _rebuildRecommendations();
    notifyListeners();
    return saved;
  }

  Future<void> _loadFeatured() async {
    final items = await _propertiesRepository.fetchFeatured(filters: filters);
    final mapped = _mapFavorites(items);
    if (mapped.isEmpty) {
      _featured = _mapFavorites(_fallbackFeatured());
    } else {
      _featured = mapped;
    }
  }

  Future<void> _loadExplore() async {
    final items = await _propertiesRepository.fetchExplore(filters: filters);
    final mapped = _mapFavorites(items);
    if (mapped.isEmpty) {
      _explore = _mapFavorites(_fallbackExplore());
    } else {
      _explore = mapped;
    }
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
    if (_feed.isEmpty) {
      final fallback = _mapFavorites(_fallbackFeed());
      _feed = fallback;
      _hasMore = fallback.length < _propertiesRepository.all().length;
    } else {
      _hasMore = result.hasMore;
    }
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
    _rebuildRecommendations();
    notifyListeners();
  }

  void _seedFallbacks() {
    _featured = _mapFavorites(_fallbackFeatured());
    _explore = _mapFavorites(_fallbackExplore());
    _feed = _mapFavorites(_fallbackFeed());
    _hasMore = _feed.length < _propertiesRepository.all().length;
  }

  Future<void> _loadRecentSearches() async {
    _recentSearches = await _prefsRepository.loadRecentSearches();
  }

  Future<void> _loadRecentViews() async {
    final ids = await _prefsRepository.loadRecentViews();
    _recentlyViewed = _mapFavorites(_propertiesRepository.pickByIds(ids));
  }

  void _rebuildRecommendations() {
    final favorites = _favoritesController.favoriteIds;
    if (favorites.isEmpty) {
      _recommended = _mapFavorites(_propertiesRepository.all().take(6).toList());
      return;
    }
    final favoriteTypes = favorites
        .map(_propertiesRepository.findById)
        .whereType<Property>()
        .map((p) => p.type)
        .toSet();
    final pool = _propertiesRepository
        .all()
        .where((property) =>
            favoriteTypes.contains(property.type) &&
            !favorites.contains(property.id))
        .take(6)
        .toList();
    _recommended = _mapFavorites(pool);
  }

  Future<void> _loadCompare() async {
    _compareIds = await _prefsRepository.loadCompare();
  }

  List<Property> _fallbackFeatured() {
    final featured = _propertiesRepository
        .all()
        .where((property) => property.isFeatured)
        .take(6)
        .toList();
    if (featured.isNotEmpty) {
      return featured;
    }
    return _propertiesRepository.all().take(6).toList();
  }

  List<Property> _fallbackExplore() {
    return _propertiesRepository.all().take(20).toList();
  }

  List<Property> _fallbackFeed() {
    return _propertiesRepository.all().take(12).toList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _filtersController.removeListener(_handleFiltersChanged);
    _favoritesController.removeListener(_handleFavoritesChanged);
    super.dispose();
  }
}
