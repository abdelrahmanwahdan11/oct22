import 'dart:math';

import '../models/asset.dart';
import '../models/portfolio.dart';
import 'market_repository.dart';

class PortfolioRepository {
  PortfolioRepository(this.marketRepository, {this.pageSize = 15}) {
    _seed();
  }

  final MarketRepository marketRepository;
  final int pageSize;

  final List<PortfolioPosition> _positions = [];

  void _seed() {
    _positions.addAll(const [
      PortfolioPosition(assetId: 'aapl', qty: 10, avgCost: 210),
      PortfolioPosition(assetId: 'btc', qty: 0.15, avgCost: 52000),
    ]);
  }

  double get totalBalance {
    return _positions.fold(0, (sum, position) {
      final quote = marketRepository.quoteFor(position.assetId);
      if (quote == null) return sum;
      return sum + quote.price * position.qty;
    });
  }

  Future<List<PortfolioView>> fetchPositions({int page = 0}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final start = page * pageSize;
    final end = min(start + pageSize, _positions.length);
    if (start >= _positions.length) return [];
    return _positions.sublist(start, end).map(_toView).toList();
  }

  PortfolioView _toView(PortfolioPosition position) {
    final asset = marketRepository.findAsset(position.assetId) ??
        const Asset(
          id: 'unknown',
          symbol: 'UNK',
          name: 'Unknown',
          type: 'stock',
          image: '',
          currency: 'USD',
        );
    final quote = marketRepository.quoteFor(position.assetId);
    final marketPrice = quote?.price ?? position.avgCost;
    final marketValue = marketPrice * position.qty;
    final costBasis = position.avgCost * position.qty;
    final pnlValue = marketValue - costBasis;
    final pnlPct = costBasis == 0 ? 0 : (pnlValue / costBasis) * 100;
    return PortfolioView(
      assetId: position.assetId,
      symbol: asset.symbol,
      name: asset.name,
      image: asset.image,
      currency: asset.currency,
      qty: position.qty,
      avgCost: position.avgCost,
      marketPrice: marketPrice,
      marketValue: marketValue,
      pnlValue: pnlValue,
      pnlPct: pnlPct,
    );
  }
}
