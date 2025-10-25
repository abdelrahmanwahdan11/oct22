import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/portfolio.dart';
import '../data/repositories/market_repository.dart';
import '../data/repositories/portfolio_repository.dart';
import '../data/repositories/prefs_repository.dart';

class PortfolioController extends ChangeNotifier {
  PortfolioController(this.portfolioRepository, this.marketRepository, this.prefsRepository);

  final PortfolioRepository portfolioRepository;
  final MarketRepository marketRepository;
  final PrefsRepository prefsRepository;

  final List<PortfolioView> _positions = [];
  bool _loading = false;
  bool _hasMore = true;
  int _page = 0;

  StreamSubscription<Map<String, Quote>>? _quotesSubscription;
  bool _initialized = false;

  List<PortfolioView> get positions => List.unmodifiable(_positions);
  bool get isLoading => _loading && _positions.isEmpty;
  bool get isLoadingMore => _loading && _positions.isNotEmpty;
  bool get hasMore => _hasMore;
  double get totalBalance => portfolioRepository.totalBalance;

  List<String> get recentRecipients => prefsRepository.loadRecents();

  Future<void> init() async {
    if (_initialized) return;
    await loadInitial();
    _quotesSubscription = marketRepository.quotesStream.listen((event) {
      _recalculate();
    });
    _initialized = true;
  }

  Future<void> loadInitial() async {
    _page = 0;
    _hasMore = true;
    await _load(reset: true);
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<void> loadMore() async {
    if (_loading || !_hasMore) return;
    _page += 1;
    await _load();
  }

  Future<void> addRecent(String value) async {
    await prefsRepository.addRecent(value);
    notifyListeners();
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading) return;
    _loading = true;
    if (reset) {
      _positions.clear();
    }
    notifyListeners();
    final page = await portfolioRepository.fetchPositions(page: _page);
    if (page.isEmpty) {
      _hasMore = false;
    } else {
      if (reset) {
        _positions
          ..clear()
          ..addAll(page);
      } else {
        _positions.addAll(page);
      }
    }
    _loading = false;
    notifyListeners();
  }

  void _recalculate() {
    unawaited(_recalculateAsync());
  }

  Future<void> _recalculateAsync() async {
    final updated = <PortfolioView>[];
    for (var page = 0; page <= _page; page++) {
      final views = await portfolioRepository.fetchPositions(page: page);
      updated.addAll(views);
    }
    _positions
      ..clear()
      ..addAll(updated);
    notifyListeners();
  }

  @override
  void dispose() {
    _quotesSubscription?.cancel();
    super.dispose();
  }
}
