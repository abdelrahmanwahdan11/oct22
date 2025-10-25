class Transaction {
  const Transaction({
    required this.id,
    required this.assetId,
    required this.txType,
    required this.amount,
    required this.currency,
    required this.to,
    required this.from,
    this.note,
    required this.timestamp,
  });

  final String id;
  final String assetId;
  final String txType;
  final double amount;
  final String currency;
  final String to;
  final String from;
  final String? note;
  final DateTime timestamp;
}
