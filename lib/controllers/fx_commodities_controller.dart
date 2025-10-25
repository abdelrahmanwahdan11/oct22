import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/fx_commodity.dart';
import '../data/repositories/fx_commodities_repository.dart';

class FxCommoditiesController extends ChangeNotifier {
  FxCommoditiesController(this.repository);

  final FxCommoditiesRepository repository;

  final List<FxPair> _pairs = [];
  List<Commodity> _gold = [];
  List<Commodity> _silver = [];
  int _page = 0;
  bool _loadingPairs = false;
  bool _hasMorePairs = true;

  StreamSubscription<void>? _updatesSubscription;

  List<FxPair> get pairs => List.unmodifiable(_pairs);
  List<Commodity> get gold => List.unmodifiable(_gold);
  List<Commodity> get silver => List.unmodifiable(_silver);
  bool get isLoadingPairs => _loadingPairs && _pairs.isEmpty;
  bool get hasMorePairs => _hasMorePairs;

  Future<void> init() async {
    await _loadPairs(reset: true);
    _refreshCommodities();
    _updatesSubscription = repository.updates.listen((_) {
      _refreshSnapshot();
    });
  }

  Future<void> refresh() async {
    _page = 0;
    _hasMorePairs = true;
    await _loadPairs(reset: true);
    _refreshCommodities();
  }

  Future<void> loadMorePairs() async {
    if (_loadingPairs || !_hasMorePairs) return;
    _page += 1;
    await _loadPairs();
  }

  Future<void> _loadPairs({bool reset = false}) async {
    if (_loadingPairs) return;
    _loadingPairs = true;
    if (reset) {
      _pairs.clear();
    }
    notifyListeners();
    final page = await repository.fetchPairs(page: _page);
    if (page.isEmpty) {
      _hasMorePairs = false;
    } else {
      if (reset) {
        _pairs
          ..clear()
          ..addAll(page);
      } else {
        _pairs.addAll(page);
      }
    }
    _loadingPairs = false;
    notifyListeners();
  }

  void _refreshSnapshot() {
    final allPairs = repository.allPairs;
    if (allPairs.isNotEmpty) {
      final maxIndex = ((_page + 1) * repository.pageSize).clamp(0, allPairs.length);
      _pairs
        ..clear()
        ..addAll(allPairs.sublist(0, maxIndex));
    }
    _refreshCommodities();
    notifyListeners();
  }

  void _refreshCommodities() {
    _gold = repository.gold();
    _silver = repository.silver();
  }

  @override
  void dispose() {
    _updatesSubscription?.cancel();
    super.dispose();
  }
}
