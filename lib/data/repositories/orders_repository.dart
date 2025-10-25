import 'dart:async';

import '../models/order.dart';

class OrdersRepository {
  final List<Order> _orders = [];
  final _ordersController = StreamController<List<Order>>.broadcast();
  int _counter = 0;

  Stream<List<Order>> get stream => _ordersController.stream;

  List<Order> get orders => List.unmodifiable(_orders);

  Future<Order> createOrder({
    required String assetId,
    required OrderSide side,
    required OrderType type,
    required double qty,
    double? limitPrice,
  }) async {
    final order = Order(
      id: 'o${++_counter}',
      assetId: assetId,
      side: side,
      type: type,
      qty: qty,
      limitPrice: limitPrice,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    _emit();
    Timer(const Duration(seconds: 2), () {
      order.status = OrderStatus.filled;
      order.createdAt = DateTime.now();
      _emit();
    });
    return order;
  }

  void _emit() {
    _ordersController.add(List.unmodifiable(_orders));
  }

  void dispose() {
    _ordersController.close();
  }
}
