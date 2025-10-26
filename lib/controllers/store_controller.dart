import 'package:flutter/foundation.dart';

import '../data/models/store_product.dart';
import '../data/repositories/store_repository.dart';

class StoreController extends ChangeNotifier {
  StoreController(this._repository);

  final StoreRepository _repository;

  List<StoreProduct> _products = const [];
  bool _isLoading = false;

  List<StoreProduct> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    _products = await _repository.fetchProducts();
    _isLoading = false;
    notifyListeners();
  }
}
