class NewsItem {
  const NewsItem({
    required this.id,
    required this.title,
    required this.source,
    required this.summary,
    required this.url,
    required this.time,
  });

  final String id;
  final String title;
  final String source;
  final String summary;
  final String url;
  final String time;
}
