class Filters {
  const Filters({
    this.query,
    this.status,
    this.types = const [],
    this.minPrice,
    this.maxPrice,
    this.minBeds,
    this.minBaths,
    this.minArea,
    this.maxArea,
    this.city,
    this.sort,
  });

  final String? query;
  final String? status;
  final List<String> types;
  final int? minPrice;
  final int? maxPrice;
  final int? minBeds;
  final int? minBaths;
  final int? minArea;
  final int? maxArea;
  final String? city;
  final String? sort;

  Filters copyWith({
    String? query,
    String? status,
    List<String>? types,
    int? minPrice,
    int? maxPrice,
    int? minBeds,
    int? minBaths,
    int? minArea,
    int? maxArea,
    String? city,
    String? sort,
  }) {
    return Filters(
      query: query ?? this.query,
      status: status ?? this.status,
      types: types ?? this.types,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minBeds: minBeds ?? this.minBeds,
      minBaths: minBaths ?? this.minBaths,
      minArea: minArea ?? this.minArea,
      maxArea: maxArea ?? this.maxArea,
      city: city ?? this.city,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toJson() => {
        'query': query,
        'status': status,
        'types': types,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'minBeds': minBeds,
        'minBaths': minBaths,
        'minArea': minArea,
        'maxArea': maxArea,
        'city': city,
        'sort': sort,
      };

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      query: json['query'] as String?,
      status: json['status'] as String?,
      types: (json['types'] as List?)?.cast<String>() ?? const [],
      minPrice: json['minPrice'] as int?,
      maxPrice: json['maxPrice'] as int?,
      minBeds: json['minBeds'] as int?,
      minBaths: json['minBaths'] as int?,
      minArea: json['minArea'] as int?,
      maxArea: json['maxArea'] as int?,
      city: json['city'] as String?,
      sort: json['sort'] as String?,
    );
  }

  static Filters empty() => const Filters();
}
