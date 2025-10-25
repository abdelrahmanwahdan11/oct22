enum OrderStatus { pending, filled, cancelled }

enum OrderSide { buy, sell }

enum OrderType { market, limit }

class Order {
  Order({
    required this.id,
    required this.assetId,
    required this.side,
    required this.type,
    required this.qty,
    this.limitPrice,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String assetId;
  final OrderSide side;
  final OrderType type;
  final double qty;
  final double? limitPrice;
  OrderStatus status;
  DateTime createdAt;
}
