import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/order.dart';
import '../data/repositories/orders_repository.dart';

class OrdersController extends ChangeNotifier {
  OrdersController(this.repository);

  final OrdersRepository repository;

  final List<Order> _orders = [];
  StreamSubscription<List<Order>>? _subscription;
  bool _initialised = false;

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> init() async {
    if (_initialised) return;
    _orders
      ..clear()
      ..addAll(repository.orders);
    _subscription = repository.stream.listen((event) {
      _orders
        ..clear()
        ..addAll(event);
      notifyListeners();
    });
    _initialised = true;
  }

  Future<Order> createOrder({
    required String assetId,
    required OrderSide side,
    required OrderType type,
    required double qty,
    double? limitPrice,
  }) async {
    final order = await repository.createOrder(
      assetId: assetId,
      side: side,
      type: type,
      qty: qty,
      limitPrice: limitPrice,
    );
    return order;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    repository.dispose();
    super.dispose();
  }
}
