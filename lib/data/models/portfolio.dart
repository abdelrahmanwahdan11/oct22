class PortfolioPosition {
  const PortfolioPosition({
    required this.assetId,
    required this.qty,
    required this.avgCost,
  });

  final String assetId;
  final double qty;
  final double avgCost;
}

class PortfolioView {
  const PortfolioView({
    required this.assetId,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currency,
    required this.qty,
    required this.avgCost,
    required this.marketPrice,
    required this.marketValue,
    required this.pnlValue,
    required this.pnlPct,
  });

  final String assetId;
  final String symbol;
  final String name;
  final String image;
  final String currency;
  final double qty;
  final double avgCost;
  final double marketPrice;
  final double marketValue;
  final double pnlValue;
  final double pnlPct;

  bool get isGain => pnlValue >= 0;
}
