class FxPair {
  const FxPair({
    required this.id,
    required this.base,
    required this.quote,
    required this.price,
    required this.changePct,
    required this.timestamp,
  });

  final String id;
  final String base;
  final String quote;
  final double price;
  final double changePct;
  final DateTime timestamp;

  bool get isGain => changePct >= 0;
}

class Commodity {
  const Commodity({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    required this.changePct,
    required this.timestamp,
  });

  final String id;
  final String name;
  final String unit;
  final double price;
  final double changePct;
  final DateTime timestamp;

  bool get isGain => changePct >= 0;
}
