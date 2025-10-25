class Asset {
  const Asset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.type,
    required this.image,
    required this.currency,
  });

  final String id;
  final String symbol;
  final String name;
  final String type;
  final String image;
  final String currency;
}

class AssetQuote {
  const AssetQuote({required this.asset, required this.quote});

  final Asset asset;
  final Quote quote;

  bool get isGain => quote.changePct >= 0;
}

class Quote {
  const Quote({
    required this.assetId,
    required this.price,
    required this.change,
    required this.changePct,
    required this.open,
    required this.high,
    required this.low,
    required this.volume,
    required this.marketCap,
    required this.timestamp,
  });

  final String assetId;
  final double price;
  final double change;
  final double changePct;
  final double open;
  final double high;
  final double low;
  final double volume;
  final double marketCap;
  final DateTime timestamp;

  Quote copyWith({
    double? price,
    double? change,
    double? changePct,
    double? open,
    double? high,
    double? low,
    double? volume,
    double? marketCap,
    DateTime? timestamp,
  }) {
    return Quote(
      assetId: assetId,
      price: price ?? this.price,
      change: change ?? this.change,
      changePct: changePct ?? this.changePct,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      volume: volume ?? this.volume,
      marketCap: marketCap ?? this.marketCap,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
