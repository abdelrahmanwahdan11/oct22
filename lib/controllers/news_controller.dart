import 'package:flutter/foundation.dart';

import '../data/models/news_item.dart';
import '../data/repositories/news_repository.dart';

class NewsController extends ChangeNotifier {
  NewsController(this.repository);

  final NewsRepository repository;

  final List<NewsItem> _items = [];
  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;

  List<NewsItem> get items => List.unmodifiable(_items);
  bool get isLoading => _loading && _items.isEmpty;
  bool get hasMore => _hasMore;

  Future<void> init() async {
    await refresh();
  }

  Future<void> refresh() async {
    _page = 0;
    _hasMore = true;
    await _load(reset: true);
  }

  Future<void> loadMore() async {
    if (_loading || !_hasMore) return;
    _page += 1;
    await _load();
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading) return;
    _loading = true;
    if (reset) {
      _items.clear();
    }
    notifyListeners();
    final page = await repository.fetchNews(page: _page);
    if (page.isEmpty) {
      _hasMore = false;
    } else {
      if (reset) {
        _items
          ..clear()
          ..addAll(page);
      } else {
        _items.addAll(page);
      }
    }
    _loading = false;
    notifyListeners();
  }
}
