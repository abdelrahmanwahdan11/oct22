import 'dart:async';

import '../models/filters.dart';
import '../models/property.dart';
import 'prefs_repository.dart';

class PropertyPage {
  PropertyPage({required this.items, required this.hasMore});

  final List<Property> items;
  final bool hasMore;
}

class PropertiesRepository {
  PropertiesRepository(this._prefsRepository) {
    _properties = _seed.map(Property.fromJson).toList();
  }

  final PrefsRepository _prefsRepository;

  late final List<Property> _properties;
  static const _delay = Duration(milliseconds: 450);
  static const _pageSize = 10;

  Future<void> hydrateCustomProperties() async {
    final custom = await _prefsRepository.loadSubmittedProperties();
    if (custom.isEmpty) return;
    final mapped = custom.map(Property.fromJson).toList();
    _properties.insertAll(0, mapped);
  }

  Future<PropertyPage> fetchProperties({
    Filters filters = const Filters(),
    String? search,
    int page = 1,
    int pageSize = _pageSize,
  }) async {
    await Future.delayed(_delay);
    final filtered = _filterList(filters: filters, search: search);
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    final slice = filtered.sublist(
      start.clamp(0, filtered.length),
      end.clamp(0, filtered.length),
    );
    return PropertyPage(
      items: slice,
      hasMore: end < filtered.length,
    );
  }

  Future<List<Property>> fetchFeatured({Filters filters = const Filters()}) async {
    await Future.delayed(_delay);
    return _filterList(filters: filters).where((p) => p.isFeatured).toList();
  }

  Future<List<Property>> fetchExplore({Filters filters = const Filters()}) async {
    await Future.delayed(_delay);
    return _filterList(filters: filters, limit: 20);
  }

  Property? findById(String id) {
    try {
      return _properties.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Property> all() => List.unmodifiable(_properties);

  void updateFavorite(String id, bool favorite) {
    final index = _properties.indexWhere((element) => element.id == id);
    if (index == -1) return;
    final property = _properties[index];
    _properties[index] = property.copyWith(favorite: favorite);
  }

  List<Property> similarProperties(String id, {int limit = 4}) {
    final subject = findById(id);
    if (subject == null) return const [];
    final peers = _properties
        .where((item) => item.id != id && item.type == subject.type)
        .take(limit)
        .toList();
    if (peers.length < limit) {
      peers.addAll(
        _properties
            .where((item) => item.id != id && item.city == subject.city)
            .take(limit - peers.length),
      );
    }
    return peers.take(limit).toList();
  }

  List<Property> pickByIds(List<String> ids) {
    if (ids.isEmpty) return const [];
    return ids
        .map(findById)
        .whereType<Property>()
        .toList();
  }

  Future<Property> submitProperty(Property property) async {
    await Future.delayed(_delay);
    _properties.insert(0, property);
    await _prefsRepository.addSubmittedProperty(property.toJson());
    return property;
  }

  List<Property> _filterList({
    Filters filters = const Filters(),
    String? search,
    int? limit,
  }) {
    Iterable<Property> data = _properties;
    if (filters.status != null && filters.status!.isNotEmpty) {
      data = data.where((p) => p.status == filters.status);
    }
    if (filters.types.isNotEmpty) {
      data = data.where((p) => filters.types.contains(p.type));
    }
    if (filters.minPrice != null) {
      data = data.where((p) => p.price >= filters.minPrice!);
    }
    if (filters.maxPrice != null) {
      data = data.where((p) => p.price <= filters.maxPrice!);
    }
    if (filters.minBeds != null) {
      data = data.where((p) => p.beds >= filters.minBeds!);
    }
    if (filters.minBaths != null) {
      data = data.where((p) => p.baths >= filters.minBaths!);
    }
    if (filters.minArea != null) {
      data = data.where((p) => p.areaM2 >= filters.minArea!);
    }
    if (filters.maxArea != null) {
      data = data.where((p) => p.areaM2 <= filters.maxArea!);
    }
    if (filters.city != null && filters.city!.isNotEmpty) {
      final cityLower = filters.city!.toLowerCase();
      data = data.where((p) => p.city.toLowerCase().contains(cityLower));
    }
    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      data = data.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.city.toLowerCase().contains(query) ||
            p.address.toLowerCase().contains(query) ||
            p.type.toLowerCase().contains(query) ||
            p.features.any((f) => f.toLowerCase().contains(query));
      });
    } else if (filters.query != null && filters.query!.isNotEmpty) {
      final query = filters.query!.toLowerCase();
      data = data.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.city.toLowerCase().contains(query) ||
            p.address.toLowerCase().contains(query) ||
            p.type.toLowerCase().contains(query) ||
            p.features.any((f) => f.toLowerCase().contains(query));
      });
    }

    final list = data.toList();
    switch (filters.sort) {
      case 'Price ↑':
      case 'price_low':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price ↓':
      case 'price_high':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Area ↑':
      case 'area_low':
        list.sort((a, b) => a.areaM2.compareTo(b.areaM2));
        break;
      case 'Area ↓':
      case 'area_high':
        list.sort((a, b) => b.areaM2.compareTo(a.areaM2));
        break;
      default:
        list.sort((a, b) => b.postedAt.compareTo(a.postedAt));
        break;
    }

    if (limit != null && list.length > limit) {
      return list.sublist(0, limit);
    }
    return list;
  }

  static const _seed = [
    {
      'id': 'p1',
      'title': 'Modern Apartment Downtown',
      'type': 'apartments',
      'status': 'for_rent',
      'price': 1200,
      'currency': 'USD',
      'city': 'Rawabi',
      'address': 'Q-Center',
      'lat': 31.97,
      'lng': 35.20,
      'beds': 2,
      'baths': 2,
      'areaM2': 110,
      'images': [
        'https://images.unsplash.com/photo-1505691938895-1758d7feb511',
      ],
      'features': ['Elevator', 'Balcony', 'AC'],
      'isFeatured': true,
      'agentId': 'a1',
      'postedAt': '2025-10-01',
      'favorite': false,
      'description':
          'A bright apartment with city views, large balcony and a smart layout.',
    },
    {
      'id': 'p2',
      'title': 'Luxury Villa with Pool',
      'type': 'villas',
      'status': 'for_sale',
      'price': 850000,
      'currency': 'USD',
      'city': 'Jericho',
      'address': 'North Hills',
      'lat': 31.86,
      'lng': 35.45,
      'beds': 5,
      'baths': 4,
      'areaM2': 420,
      'images': [
        'https://images.unsplash.com/photo-1564013799919-ab600027ffc6',
      ],
      'features': ['Pool', 'Garden', 'Garage'],
      'isFeatured': true,
      'agentId': 'a2',
      'postedAt': '2025-10-15',
      'favorite': true,
      'description':
          'Resort-style villa featuring an infinity pool, double-height living and private cinema.',
    },
    {
      'id': 'p3',
      'title': 'Mountain View Cabin',
      'type': 'cabins',
      'status': 'for_rent',
      'price': 230,
      'currency': 'USD',
      'city': 'Ramallah',
      'address': 'Green Hills',
      'lat': 31.90,
      'lng': 35.19,
      'beds': 2,
      'baths': 1,
      'areaM2': 75,
      'images': [
        'https://images.unsplash.com/photo-1501183638710-841dd1904471',
      ],
      'features': ['Fireplace', 'Terrace', 'Mountain view'],
      'isFeatured': true,
      'agentId': 'a1',
      'postedAt': '2025-09-18',
      'favorite': false,
      'description':
          'Cozy escape surrounded by pine trees and panoramic valley views.',
    },
    {
      'id': 'p4',
      'title': 'Urban Loft with Skyline',
      'type': 'apartments',
      'status': 'for_sale',
      'price': 390000,
      'currency': 'USD',
      'city': 'Nablus',
      'address': 'Cedar Street',
      'lat': 32.22,
      'lng': 35.25,
      'beds': 3,
      'baths': 3,
      'areaM2': 180,
      'images': [
        'https://images.unsplash.com/photo-1494526585095-c41746248156',
      ],
      'features': ['Smart Home', 'Roof Deck', 'Gym Access'],
      'isFeatured': false,
      'agentId': 'a2',
      'postedAt': '2025-08-11',
      'favorite': false,
      'description':
          'Industrial-inspired loft with double height ceilings and private rooftop.',
    },
    {
      'id': 'p5',
      'title': 'Riverside Retreat Cottage',
      'type': 'cabins',
      'status': 'for_sale',
      'price': 215000,
      'currency': 'USD',
      'city': 'Tulkarm',
      'address': 'Riverbank Road',
      'lat': 32.31,
      'lng': 35.03,
      'beds': 3,
      'baths': 2,
      'areaM2': 160,
      'images': [
        'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6',
      ],
      'features': ['River view', 'Sauna', 'Outdoor kitchen'],
      'isFeatured': false,
      'agentId': 'a1',
      'postedAt': '2025-07-05',
      'favorite': false,
      'description': 'Warm timber finishes with a spacious deck over the river.',
    },
    {
      'id': 'p6',
      'title': 'Desert Edge Villa',
      'type': 'villas',
      'status': 'for_sale',
      'price': 620000,
      'currency': 'USD',
      'city': 'Hebron',
      'address': 'Sunset Drive',
      'lat': 31.53,
      'lng': 35.09,
      'beds': 4,
      'baths': 4,
      'areaM2': 320,
      'images': [
        'https://images.unsplash.com/photo-1505691938895-1758d7feb511',
      ],
      'features': ['Patio', 'Cinema room', 'Solar panels'],
      'isFeatured': false,
      'agentId': 'a2',
      'postedAt': '2025-06-22',
      'favorite': false,
      'description': 'Open-plan villa designed for indoor-outdoor living.',
    },
    {
      'id': 'p7',
      'title': 'Garden Courtyard House',
      'type': 'apartments',
      'status': 'for_rent',
      'price': 980,
      'currency': 'USD',
      'city': 'Bethlehem',
      'address': 'Olive Lane',
      'lat': 31.71,
      'lng': 35.20,
      'beds': 3,
      'baths': 2,
      'areaM2': 150,
      'images': [
        'https://images.unsplash.com/photo-1494526585095-c41746248156',
      ],
      'features': ['Courtyard', 'Library', 'Workspace'],
      'isFeatured': false,
      'agentId': 'a1',
      'postedAt': '2025-05-17',
      'favorite': false,
      'description': 'Biophilic-inspired interiors wrapped around a lush courtyard.',
    },
    {
      'id': 'p8',
      'title': 'Skyline Penthouse',
      'type': 'apartments',
      'status': 'for_sale',
      'price': 1020000,
      'currency': 'USD',
      'city': 'Jerusalem',
      'address': 'Skyline Tower',
      'lat': 31.77,
      'lng': 35.21,
      'beds': 4,
      'baths': 4,
      'areaM2': 360,
      'images': [
        'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6',
      ],
      'features': ['Panoramic view', 'Spa', 'Helipad access'],
      'isFeatured': true,
      'agentId': 'a2',
      'postedAt': '2025-04-28',
      'favorite': false,
      'description': 'Signature penthouse with wraparound terrace and private spa.',
    },
    {
      'id': 'p9',
      'title': 'Beachfront Sanctuary',
      'type': 'villas',
      'status': 'for_rent',
      'price': 3400,
      'currency': 'USD',
      'city': 'Gaza',
      'address': 'Azure Beach',
      'lat': 31.52,
      'lng': 34.45,
      'beds': 6,
      'baths': 5,
      'areaM2': 480,
      'images': [
        'https://images.unsplash.com/photo-1564013799919-ab600027ffc6',
      ],
      'features': ['Infinity pool', 'Private pier', 'Outdoor cinema'],
      'isFeatured': false,
      'agentId': 'a1',
      'postedAt': '2025-03-10',
      'favorite': false,
      'description': 'Ocean breeze villa with expansive outdoor lounge decks.',
    },
    {
      'id': 'p10',
      'title': 'Cityscape Executive Suite',
      'type': 'apartments',
      'status': 'for_rent',
      'price': 1500,
      'currency': 'USD',
      'city': 'Ramallah',
      'address': 'Central Avenue',
      'lat': 31.90,
      'lng': 35.19,
      'beds': 2,
      'baths': 2,
      'areaM2': 120,
      'images': [
        'https://images.unsplash.com/photo-1505691938895-1758d7feb511',
      ],
      'features': ['Concierge', 'Gym', 'Workspace'],
      'isFeatured': false,
      'agentId': 'a2',
      'postedAt': '2025-02-08',
      'favorite': false,
      'description': 'Premium serviced apartment with skyline lounge access.',
    },
    {
      'id': 'p11',
      'title': 'Countryside Farmhouse',
      'type': 'villas',
      'status': 'for_sale',
      'price': 280000,
      'currency': 'USD',
      'city': 'Jenin',
      'address': 'Harvest Road',
      'lat': 32.46,
      'lng': 35.29,
      'beds': 4,
      'baths': 3,
      'areaM2': 250,
      'images': [
        'https://images.unsplash.com/photo-1494526585095-c41746248156',
      ],
      'features': ['Barn', 'Orchard', 'Playground'],
      'isFeatured': false,
      'agentId': 'a1',
      'postedAt': '2025-01-02',
      'favorite': false,
      'description': 'Sun-drenched farmhouse perfect for weekend escapes.',
    },
  ];
}
