import 'dart:async';
import 'dart:math';

import '../models/asset.dart';
class MarketRepository {
  MarketRepository({this.pageSize = 15}) {
    _seed();
    _startTicker();
  }

  final int pageSize;

  final List<Asset> _assets = [];
  final Map<String, Quote> _quotes = {};

  final _quoteStreamController = StreamController<Map<String, Quote>>.broadcast();
  Timer? _ticker;
  final _random = Random();

  Stream<Map<String, Quote>> get quotesStream => _quoteStreamController.stream;

  List<Asset> get assets => List.unmodifiable(_assets);

  Quote? quoteFor(String assetId) => _quotes[assetId];

  Asset? findAsset(String id) {
    try {
      return _assets.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  AssetQuote? findAssetQuote(String id) {
    final asset = findAsset(id);
    if (asset == null) return null;
    final quote = _quotes[asset.id];
    if (quote == null) return null;
    return AssetQuote(asset: asset, quote: quote);
  }

  Future<List<AssetQuote>> fetchPage({int page = 0, String? type, String? search}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    Iterable<Asset> filtered = _assets;
    if (type != null) {
      filtered = filtered.where((asset) => asset.type == type);
    }
    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase().trim();
      final collapsed = query.replaceAll(RegExp(r'\s+'), '');
      filtered = filtered.where((asset) {
        final symbol = asset.symbol.toLowerCase();
        final name = asset.name.toLowerCase();
        final currency = asset.currency.toLowerCase();
        final normalizedName = name.replaceAll(RegExp(r'\s+'), '');
        return symbol.contains(query) ||
            name.contains(query) ||
            currency.contains(query) ||
            symbol.contains(collapsed) ||
            normalizedName.contains(collapsed);
      });
    }
    final list = filtered.toList();
    final start = page * pageSize;
    final end = min(start + pageSize, list.length);
    if (start >= list.length) return [];
    return list.sublist(start, end).map(_assetQuote).toList();
  }

  Future<List<AssetQuote>> fetchTrending() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final sorted = _quotes.values.toList()
      ..sort((a, b) => b.changePct.compareTo(a.changePct));
    final ids = sorted.take(10).map((q) => q.assetId);
    return ids.map((id) => _assetQuote(_assets.firstWhere((asset) => asset.id == id))).toList();
  }

  Future<List<AssetQuote>> fetchMostActive({int page = 0}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final sorted = _quotes.values.toList()
      ..sort((a, b) => b.volume.compareTo(a.volume));
    final start = page * pageSize;
    final end = min(start + pageSize, sorted.length);
    if (start >= sorted.length) return [];
    final slice = sorted.sublist(start, end);
    return slice.map((quote) => _assetQuote(_assets.firstWhere((a) => a.id == quote.assetId))).toList();
  }

  Future<void> dispose() async {
    await _quoteStreamController.close();
    _ticker?.cancel();
  }

  AssetQuote _assetQuote(Asset asset) {
    final quote = _quotes[asset.id];
    return AssetQuote(asset: asset, quote: quote!);
  }

  void _seed() {
    final now = DateTime.now();
    _assets.addAll(const [
      Asset(
        id: 'aapl',
        symbol: 'AAPL',
        name: 'Apple',
        type: 'stock',
        image: 'https://logo.clearbit.com/apple.com',
        currency: 'USD',
      ),
      Asset(
        id: 'nvda',
        symbol: 'NVDA',
        name: 'NVIDIA',
        type: 'stock',
        image: 'https://logo.clearbit.com/nvidia.com',
        currency: 'USD',
      ),
      Asset(
        id: 'tsla',
        symbol: 'TSLA',
        name: 'Tesla',
        type: 'stock',
        image: 'https://logo.clearbit.com/tesla.com',
        currency: 'USD',
      ),
      Asset(
        id: 'msft',
        symbol: 'MSFT',
        name: 'Microsoft',
        type: 'stock',
        image: 'https://logo.clearbit.com/microsoft.com',
        currency: 'USD',
      ),
      Asset(
        id: 'amzn',
        symbol: 'AMZN',
        name: 'Amazon',
        type: 'stock',
        image: 'https://logo.clearbit.com/amazon.com',
        currency: 'USD',
      ),
      Asset(
        id: 'googl',
        symbol: 'GOOGL',
        name: 'Alphabet',
        type: 'stock',
        image: 'https://logo.clearbit.com/abc.xyz',
        currency: 'USD',
      ),
      Asset(
        id: 'meta',
        symbol: 'META',
        name: 'Meta Platforms',
        type: 'stock',
        image: 'https://logo.clearbit.com/meta.com',
        currency: 'USD',
      ),
      Asset(
        id: 'coin',
        symbol: 'COIN',
        name: 'Coinbase',
        type: 'stock',
        image: 'https://logo.clearbit.com/coinbase.com',
        currency: 'USD',
      ),
      Asset(
        id: 'btc',
        symbol: 'BTC',
        name: 'Bitcoin',
        type: 'crypto',
        image: 'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
        currency: 'USD',
      ),
      Asset(
        id: 'eth',
        symbol: 'ETH',
        name: 'Ethereum',
        type: 'crypto',
        image: 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
        currency: 'USD',
      ),
      Asset(
        id: 'sol',
        symbol: 'SOL',
        name: 'Solana',
        type: 'crypto',
        image: 'https://cryptologos.cc/logos/solana-sol-logo.png',
        currency: 'USD',
      ),
      Asset(
        id: 'avax',
        symbol: 'AVAX',
        name: 'Avalanche',
        type: 'crypto',
        image: 'https://cryptologos.cc/logos/avalanche-avax-logo.png',
        currency: 'USD',
      ),
      Asset(
        id: 'bnb',
        symbol: 'BNB',
        name: 'BNB',
        type: 'crypto',
        image: 'https://cryptologos.cc/logos/bnb-bnb-logo.png',
        currency: 'USD',
      ),
    ]);

    final seedQuotes = [
      Quote(
        assetId: 'aapl',
        price: 226.21,
        change: 2.75,
        changePct: 1.23,
        open: 223.0,
        high: 227.1,
        low: 221.9,
        volume: 120000000,
        marketCap: 2850000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'nvda',
        price: 486.10,
        change: -3.12,
        changePct: -0.64,
        open: 489.0,
        high: 492.0,
        low: 480.5,
        volume: 90000000,
        marketCap: 1200000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'tsla',
        price: 250.0,
        change: 4.90,
        changePct: 2.0,
        open: 244.5,
        high: 251.2,
        low: 240.3,
        volume: 78000000,
        marketCap: 800000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'msft',
        price: 420.15,
        change: 3.2,
        changePct: 0.77,
        open: 417.0,
        high: 422.8,
        low: 415.5,
        volume: 32000000,
        marketCap: 3200000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'amzn',
        price: 189.45,
        change: -1.2,
        changePct: -0.63,
        open: 190.65,
        high: 192.0,
        low: 187.8,
        volume: 42000000,
        marketCap: 1950000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'googl',
        price: 168.32,
        change: 0.98,
        changePct: 0.59,
        open: 167.2,
        high: 169.4,
        low: 165.8,
        volume: 31000000,
        marketCap: 2100000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'meta',
        price: 512.60,
        change: -5.4,
        changePct: -1.04,
        open: 518.0,
        high: 521.4,
        low: 508.2,
        volume: 28000000,
        marketCap: 1300000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'coin',
        price: 242.18,
        change: 6.8,
        changePct: 2.89,
        open: 235.4,
        high: 244.9,
        low: 232.0,
        volume: 26000000,
        marketCap: 60000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'btc',
        price: 67350.0,
        change: -420.0,
        changePct: -0.62,
        open: 67500,
        high: 68100,
        low: 66800,
        volume: 38000,
        marketCap: 1300000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'eth',
        price: 3520.0,
        change: 35.0,
        changePct: 1.0,
        open: 3480,
        high: 3550,
        low: 3440,
        volume: 210000,
        marketCap: 420000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'sol',
        price: 152.35,
        change: 4.5,
        changePct: 3.05,
        open: 147.8,
        high: 153.9,
        low: 145.1,
        volume: 1200000,
        marketCap: 68000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'avax',
        price: 45.60,
        change: -0.8,
        changePct: -1.72,
        open: 46.4,
        high: 47.2,
        low: 44.9,
        volume: 890000,
        marketCap: 17000000000,
        timestamp: now,
      ),
      Quote(
        assetId: 'bnb',
        price: 598.30,
        change: 12.6,
        changePct: 2.15,
        open: 585.7,
        high: 600.2,
        low: 580.1,
        volume: 320000,
        marketCap: 92000000000,
        timestamp: now,
      ),
    ];

    for (final quote in seedQuotes) {
      _quotes[quote.assetId] = quote;
    }

  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateQuotes();
      _quoteStreamController.add(Map.unmodifiable(_quotes));
    });
  }

  void _updateQuotes() {
    final now = DateTime.now();
    for (final entry in _quotes.entries) {
      final current = entry.value;
      final deltaPct = (_random.nextDouble() * 0.6 - 0.3) / 100;
      final newPrice = (current.price * (1 + deltaPct)).clamp(0.01, double.infinity);
      final newHigh = max(current.high, newPrice);
      final newLow = min(current.low, newPrice);
      final change = newPrice - current.open;
      final changePct = current.open == 0 ? 0 : (change / current.open) * 100;
      _quotes[entry.key] = current.copyWith(
        price: newPrice,
        change: change,
        changePct: changePct,
        high: newHigh,
        low: newLow,
        timestamp: now,
      );
    }
  }
}
