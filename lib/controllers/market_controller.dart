import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/asset.dart';
import '../data/repositories/market_repository.dart';
import '../data/repositories/prefs_repository.dart';

class MarketController extends ChangeNotifier {
  MarketController(this.marketRepository, this.prefsRepository);

  final MarketRepository marketRepository;
  final PrefsRepository prefsRepository;

  final List<AssetQuote> _top = [];
  final List<AssetQuote> _trending = [];
  final List<AssetQuote> _mostActive = [];
  Set<String> _watchlist = {};

  int _topPage = 0;
  int _activePage = 0;
  bool _loadingTop = false;
  bool _loadingActive = false;
  bool _hasMoreTop = true;
  bool _hasMoreActive = true;
  String _searchQuery = '';
  String? _typeFilter;

  StreamSubscription<Map<String, Quote>>? _quotesSubscription;
  Timer? _searchDebounce;
  bool _initialized = false;

  List<AssetQuote> get top => List.unmodifiable(_top);
  List<AssetQuote> get trending => List.unmodifiable(_trending);
  List<AssetQuote> get mostActive => List.unmodifiable(_mostActive);
  List<Asset> get allAssets => List.unmodifiable(marketRepository.assets);
  Set<String> get watchlist => _watchlist;
  List<AssetQuote> get watchlistAssets => _watchlist
      .map((id) => marketRepository.findAssetQuote(id))
      .whereType<AssetQuote>()
      .toList();
  bool get isLoadingTop => _loadingTop && _top.isEmpty;
  bool get isLoadingActive => _loadingActive && _mostActive.isEmpty;
  bool get isLoadingMoreTop => _loadingTop && _top.isNotEmpty;
  bool get isLoadingMoreActive => _loadingActive && _mostActive.isNotEmpty;
  bool get hasMoreTop => _hasMoreTop;
  bool get hasMoreActive => _hasMoreActive;
  String get searchQuery => _searchQuery;
  String? get typeFilter => _typeFilter;

  Future<void> init() async {
    if (_initialized) return;
    _watchlist = prefsRepository.loadWatchlist().toSet();
    await Future.wait([
      _loadTop(reset: true),
      _loadTrending(),
      _loadMostActive(reset: true),
    ]);
    _quotesSubscription = marketRepository.quotesStream.listen(_onQuotesUpdate);
    _initialized = true;
  }

  Future<void> refresh() async {
    _resetTopPagination();
    _activePage = 0;
    _hasMoreActive = true;
    _searchDebounce?.cancel();
    await Future.wait([
      _loadTop(reset: true),
      _loadTrending(),
      _loadMostActive(reset: true),
    ]);
  }

  Future<void> loadMoreTop() async {
    if (_loadingTop || !_hasMoreTop) return;
    _loadingTop = true;
    notifyListeners();
    _topPage += 1;
    final page = await marketRepository.fetchPage(
      page: _topPage,
      search: _searchQuery,
      type: _typeFilter,
    );
    if (page.isEmpty) {
      _hasMoreTop = false;
    } else {
      _top.addAll(page);
    }
    _loadingTop = false;
    notifyListeners();
  }

  Future<void> loadMoreActive() async {
    if (_loadingActive || !_hasMoreActive) return;
    _loadingActive = true;
    notifyListeners();
    _activePage += 1;
    final page = await marketRepository.fetchMostActive(page: _activePage);
    if (page.isEmpty) {
      _hasMoreActive = false;
    } else {
      _mostActive.addAll(page);
    }
    _loadingActive = false;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    final normalized = value.trim();
    if (_searchQuery == normalized) return;
    _searchQuery = normalized;
    _resetTopPagination();
    _top.clear();
    _loadingTop = true;
    notifyListeners();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () async {
      await _loadTop(reset: true, force: true);
    });
  }

  Future<void> setTypeFilter(String? type) async {
    if (_typeFilter == type) return;
    _typeFilter = type;
    _resetTopPagination();
    _top.clear();
    _loadingTop = true;
    notifyListeners();
    await _loadTop(reset: true, force: true);
  }

  bool isWatched(String id) => _watchlist.contains(id);

  AssetQuote? assetQuote(String id) => marketRepository.findAssetQuote(id);

  Future<void> toggleWatch(String id) async {
    _watchlist = (await prefsRepository.toggleWatch(id)).toSet();
    notifyListeners();
  }

  void _onQuotesUpdate(Map<String, Quote> quotes) {
    bool changed = false;
    for (var i = 0; i < _top.length; i++) {
      final quote = quotes[_top[i].asset.id];
      if (quote != null) {
        _top[i] = AssetQuote(asset: _top[i].asset, quote: quote);
        changed = true;
      }
    }
    for (var i = 0; i < _trending.length; i++) {
      final quote = quotes[_trending[i].asset.id];
      if (quote != null) {
        _trending[i] = AssetQuote(asset: _trending[i].asset, quote: quote);
        changed = true;
      }
    }
    for (var i = 0; i < _mostActive.length; i++) {
      final quote = quotes[_mostActive[i].asset.id];
      if (quote != null) {
        _mostActive[i] = AssetQuote(asset: _mostActive[i].asset, quote: quote);
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  Future<void> _loadTop({bool reset = false, bool force = false}) async {
    if (_loadingTop && !force) return;
    _loadingTop = true;
    if (reset) {
      _top.clear();
    }
    notifyListeners();
    final page = await marketRepository.fetchPage(
      page: _topPage,
      search: _searchQuery,
      type: _typeFilter,
    );
    if (reset) {
      _top
        ..clear()
        ..addAll(page);
    } else {
      _top.addAll(page);
    }
    _hasMoreTop = page.length == marketRepository.pageSize;
    _loadingTop = false;
    notifyListeners();
  }

  void _resetTopPagination() {
    _topPage = 0;
    _hasMoreTop = true;
  }

  Future<void> _loadTrending() async {
    final data = await marketRepository.fetchTrending();
    _trending
      ..clear()
      ..addAll(data);
    notifyListeners();
  }

  Future<void> _loadMostActive({bool reset = false}) async {
    if (_loadingActive) return;
    _loadingActive = true;
    if (reset) {
      _mostActive.clear();
    }
    notifyListeners();
    final page = await marketRepository.fetchMostActive(page: _activePage);
    if (reset) {
      _mostActive
        ..clear()
        ..addAll(page);
    } else {
      _mostActive.addAll(page);
    }
    _hasMoreActive = page.length == marketRepository.pageSize;
    _loadingActive = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _quotesSubscription?.cancel();
    super.dispose();
  }
}
