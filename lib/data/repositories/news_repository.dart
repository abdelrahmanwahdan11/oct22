import 'dart:math';

import '../models/news_item.dart';

class NewsRepository {
  NewsRepository({this.pageSize = 15}) {
    _seed();
  }

  final int pageSize;
  final List<NewsItem> _news = [];

  void _seed() {
    _news.addAll(const [
      NewsItem(
        id: 'n1',
        title: 'Tech stocks rally on earnings',
        source: 'Reuters',
        summary: 'Apple and Nvidia lead gains...',
        url: 'https://example.com/1',
        time: '1h',
      ),
      NewsItem(
        id: 'n2',
        title: 'Bitcoin stabilizes above $67k',
        source: 'CoinDesk',
        summary: 'Market shrugs off volatility...',
        url: 'https://example.com/2',
        time: '2h',
      ),
      NewsItem(
        id: 'n3',
        title: 'Gold inches higher as dollar eases',
        source: 'Bloomberg',
        summary: 'Investors seek haven assets amid market jitters...',
        url: 'https://example.com/3',
        time: '3h',
      ),
    ]);
  }

  Future<List<NewsItem>> fetchNews({int page = 0}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final start = page * pageSize;
    final end = min(start + pageSize, _news.length);
    if (start >= _news.length) return [];
    return _news.sublist(start, end);
  }
}
