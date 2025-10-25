import 'dart:async';
import 'dart:math';

import '../models/fx_commodity.dart';

class FxCommoditiesRepository {
  FxCommoditiesRepository({this.pageSize = 15}) {
    _seed();
    _startTicker();
  }

  final int pageSize;

  final List<FxPair> _fxPairs = [];
  final List<Commodity> _commodities = [];
  Timer? _ticker;
  final _random = Random();
  final _updates = StreamController<void>.broadcast();

  Stream<void> get updates => _updates.stream;

  List<FxPair> get allPairs => List.unmodifiable(_fxPairs);

  List<Commodity> get allCommodities => List.unmodifiable(_commodities);

  Future<List<FxPair>> fetchPairs({int page = 0}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final start = page * pageSize;
    final end = min(start + pageSize, _fxPairs.length);
    if (start >= _fxPairs.length) return [];
    return _fxPairs.sublist(start, end);
  }

  List<Commodity> gold() =>
      _commodities.where((element) => element.id == 'gold').toList(growable: false);

  List<Commodity> silver() =>
      _commodities.where((element) => element.id == 'silver').toList(growable: false);

  void _seed() {
    final now = DateTime.now();
    _fxPairs.addAll([
      FxPair(
        id: 'eurusd',
        base: 'EUR',
        quote: 'USD',
        price: 1.0875,
        changePct: 0.12,
        timestamp: now,
      ),
      FxPair(
        id: 'usdjpy',
        base: 'USD',
        quote: 'JPY',
        price: 150.30,
        changePct: -0.08,
        timestamp: now,
      ),
      FxPair(
        id: 'gbpusd',
        base: 'GBP',
        quote: 'USD',
        price: 1.2723,
        changePct: 0.05,
        timestamp: now,
      ),
      FxPair(
        id: 'audusd',
        base: 'AUD',
        quote: 'USD',
        price: 0.6625,
        changePct: -0.11,
        timestamp: now,
      ),
    ]);

    _commodities.addAll([
      Commodity(
        id: 'gold',
        name: 'Gold',
        unit: 'oz',
        price: 2345.20,
        changePct: 0.35,
        timestamp: now,
      ),
      Commodity(
        id: 'silver',
        name: 'Silver',
        unit: 'oz',
        price: 28.45,
        changePct: -0.25,
        timestamp: now,
      ),
    ]);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 5), (_) {
      final now = DateTime.now();
      for (var i = 0; i < _fxPairs.length; i++) {
        final pair = _fxPairs[i];
        final deltaPct = (_random.nextDouble() * 0.6 - 0.3) / 100;
        final newPrice = double.parse((pair.price * (1 + deltaPct)).toStringAsFixed(5));
        final newChange = double.parse((pair.changePct + deltaPct * 100).toStringAsFixed(2));
        _fxPairs[i] = FxPair(
          id: pair.id,
          base: pair.base,
          quote: pair.quote,
          price: newPrice,
          changePct: newChange,
          timestamp: now,
        );
      }
      for (var i = 0; i < _commodities.length; i++) {
        final commodity = _commodities[i];
        final deltaPct = (_random.nextDouble() * 0.6 - 0.3) / 100;
        final newPrice = double.parse((commodity.price * (1 + deltaPct)).toStringAsFixed(2));
        final newChange = double.parse((commodity.changePct + deltaPct * 100).toStringAsFixed(2));
        _commodities[i] = Commodity(
          id: commodity.id,
          name: commodity.name,
          unit: commodity.unit,
          price: newPrice,
          changePct: newChange,
          timestamp: now,
        );
      }
      _updates.add(null);
    });
  }

  void dispose() {
    _ticker?.cancel();
    _updates.close();
  }
}
