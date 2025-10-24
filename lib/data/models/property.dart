class Property {
  const Property({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.price,
    required this.currency,
    required this.city,
    required this.address,
    required this.lat,
    required this.lng,
    required this.beds,
    required this.baths,
    required this.areaM2,
    required this.images,
    required this.features,
    required this.isFeatured,
    required this.agentId,
    required this.postedAt,
    required this.favorite,
    this.description,
  });

  final String id;
  final String title;
  final String type;
  final String status;
  final num price;
  final String currency;
  final String city;
  final String address;
  final double lat;
  final double lng;
  final int beds;
  final int baths;
  final int areaM2;
  final List<String> images;
  final List<String> features;
  final bool isFeatured;
  final String agentId;
  final DateTime postedAt;
  final bool favorite;
  final String? description;

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      price: json['price'] as num,
      currency: json['currency'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      beds: json['beds'] as int,
      baths: json['baths'] as int,
      areaM2: json['areaM2'] as int,
      images: (json['images'] as List).cast<String>(),
      features: (json['features'] as List).cast<String>(),
      isFeatured: json['isFeatured'] as bool,
      agentId: json['agentId'] as String,
      postedAt: DateTime.parse(json['postedAt'] as String),
      favorite: json['favorite'] as bool? ?? false,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'status': status,
        'price': price,
        'currency': currency,
        'city': city,
        'address': address,
        'lat': lat,
        'lng': lng,
        'beds': beds,
        'baths': baths,
        'areaM2': areaM2,
        'images': images,
        'features': features,
        'isFeatured': isFeatured,
        'agentId': agentId,
        'postedAt': postedAt.toIso8601String(),
        'favorite': favorite,
        'description': description,
      };

  Property copyWith({
    String? title,
    String? type,
    String? status,
    num? price,
    String? currency,
    String? city,
    String? address,
    double? lat,
    double? lng,
    int? beds,
    int? baths,
    int? areaM2,
    List<String>? images,
    List<String>? features,
    bool? isFeatured,
    String? agentId,
    DateTime? postedAt,
    bool? favorite,
    String? description,
  }) {
    return Property(
      id: id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      city: city ?? this.city,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      beds: beds ?? this.beds,
      baths: baths ?? this.baths,
      areaM2: areaM2 ?? this.areaM2,
      images: images ?? this.images,
      features: features ?? this.features,
      isFeatured: isFeatured ?? this.isFeatured,
      agentId: agentId ?? this.agentId,
      postedAt: postedAt ?? this.postedAt,
      favorite: favorite ?? this.favorite,
      description: description ?? this.description,
    );
  }
}
