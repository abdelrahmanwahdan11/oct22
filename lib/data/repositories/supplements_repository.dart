import 'dart:async';

import '../models/supplement.dart';

class SupplementsRepository {
  SupplementsRepository({this.pageSize = 12});

  final int pageSize;
  final Duration simulatedDelay = const Duration(milliseconds: 450);

  final List<Supplement> _supplements = [
    Supplement(
      id: 'sup-omega3',
      name: 'Omega-3 Balance',
      image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b',
      category: 'heart',
      tags: ['heart', 'energy', 'focus'],
      description:
          'High potency omega-3 formula to support cardiovascular health and mental clarity.',
      benefits: [
        'Supports heart rhythm',
        'Reduces inflammation',
        'Boosts cognitive focus',
      ],
      dosage: '2 softgels',
      schedule: 'Morning with breakfast',
      rating: 4.8,
    ),
    Supplement(
      id: 'sup-vitd',
      name: 'Vitamin D3+K2',
      image: 'https://images.unsplash.com/photo-1582719478185-ff61da3d5f3f',
      category: 'energy',
      tags: ['energy', 'immunity'],
      description: 'Essential sunshine vitamins blended for optimal absorption and immunity.',
      benefits: ['Balances mood', 'Strengthens bones', 'Supports immunity'],
      dosage: '1 capsule',
      schedule: 'Midday after meal',
      rating: 4.9,
    ),
    Supplement(
      id: 'sup-mag',
      name: 'Magnesium Restore',
      image: 'https://images.unsplash.com/photo-1595433707802-6b2626f3f1a4',
      category: 'stress',
      tags: ['stress', 'sleep'],
      description: 'Chelated magnesium blend for nightly relaxation and muscle recovery.',
      benefits: ['Improves sleep', 'Relaxes muscles', 'Calms nervous system'],
      dosage: '2 tablets',
      schedule: 'Evening before bed',
      rating: 4.7,
    ),
    Supplement(
      id: 'sup-bcomplex',
      name: 'B-Complex Elevate',
      image: 'https://images.unsplash.com/photo-1585238342028-4bbc5a00e12a',
      category: 'energy',
      tags: ['energy', 'stress'],
      description: 'Complete spectrum of B vitamins with adaptogens for steady energy.',
      benefits: ['Supports metabolism', 'Stabilizes mood', 'Improves focus'],
      dosage: '1 capsule',
      schedule: 'Morning with water',
      rating: 4.6,
    ),
    Supplement(
      id: 'sup-iron',
      name: 'Iron Gentle+ C',
      image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b',
      category: 'energy',
      tags: ['energy', 'blood'],
      description: 'Bioavailable iron chelate with vitamin C to enhance absorption.',
      benefits: ['Combats fatigue', 'Supports blood oxygen', 'Boosts immunity'],
      dosage: '1 tablet',
      schedule: 'Afternoon with meal',
      rating: 4.5,
    ),
    Supplement(
      id: 'sup-ashwagandha',
      name: 'Ashwagandha Calm',
      image: 'https://images.unsplash.com/photo-1585238342028-4bbc5a00e12a',
      category: 'stress',
      tags: ['stress', 'sleep', 'mood'],
      description: 'Adaptogenic herb to regulate cortisol and ease daily stress.',
      benefits: ['Balances cortisol', 'Supports sleep cycle', 'Promotes calm focus'],
      dosage: '2 capsules',
      schedule: 'Evening with tea',
      rating: 4.9,
    ),
    Supplement(
      id: 'sup-probiotic',
      name: 'Biome Harmony',
      image: 'https://images.unsplash.com/photo-1595433707802-6b2626f3f1a4',
      category: 'energy',
      tags: ['gut', 'immunity'],
      description:
          'Multi-strain probiotic to nourish gut flora and support immune balance.',
      benefits: ['Improves digestion', 'Enhances immunity', 'Reduces bloating'],
      dosage: '1 sachet',
      schedule: 'Morning before meal',
      rating: 4.4,
    ),
    Supplement(
      id: 'sup-vitc',
      name: 'Vitamin C Radiance',
      image: 'https://images.unsplash.com/photo-1582719478185-ff61da3d5f3f',
      category: 'energy',
      tags: ['immunity', 'skin'],
      description: 'Buffered vitamin C with citrus bioflavonoids for daily antioxidant support.',
      benefits: ['Supports immune response', 'Brightens skin', 'Protects cells'],
      dosage: '2 chewables',
      schedule: 'Morning with breakfast',
      rating: 4.3,
    ),
    Supplement(
      id: 'sup-zinc',
      name: 'Zinc Guard',
      image: 'https://images.unsplash.com/photo-1595433707802-6b2626f3f1a4',
      category: 'stress',
      tags: ['immunity', 'skin', 'stress'],
      description:
          'Chelated zinc with botanical cofactors to support hormones and immune response.',
      benefits: ['Balances hormones', 'Supports recovery', 'Defends immunity'],
      dosage: '1 capsule',
      schedule: 'Night with snack',
      rating: 4.2,
    ),
    Supplement(
      id: 'sup-multi',
      name: 'Daily Multi Glow',
      image: 'https://images.unsplash.com/photo-1585238342028-4bbc5a00e12a',
      category: 'energy',
      tags: ['energy', 'stress', 'immunity'],
      description: 'Complete micronutrient complex tailored to female physiology.',
      benefits: ['Fills micronutrient gaps', 'Enhances resilience', 'Boosts vitality'],
      dosage: '2 capsules',
      schedule: 'Morning with smoothie',
      rating: 4.8,
    ),
    Supplement(
      id: 'sup-collagen',
      name: 'Collagen Peptides+',
      image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b',
      category: 'heart',
      tags: ['skin', 'joints'],
      description: 'Hydrolyzed collagen with vitamin C for skin, hair, and joint support.',
      benefits: ['Supports skin elasticity', 'Strengthens nails', 'Supports joints'],
      dosage: '1 scoop',
      schedule: 'Anytime in beverage',
      rating: 4.6,
    ),
    Supplement(
      id: 'sup-coq10',
      name: 'CoQ10 Vitality',
      image: 'https://images.unsplash.com/photo-1582719478185-ff61da3d5f3f',
      category: 'heart',
      tags: ['heart', 'energy'],
      description:
          'Active ubiquinol form of CoQ10 to energize cells and maintain heart function.',
      benefits: ['Energizes mitochondria', 'Protects heart', 'Reduces oxidative stress'],
      dosage: '1 softgel',
      schedule: 'Evening with dinner',
      rating: 4.5,
    ),
  ];

  List<String> get categories =>
      _supplements.map((s) => s.category).toSet().toList()..sort();

  List<String> get tags => _supplements.expand((s) => s.tags).toSet().toList()..sort();

  Future<List<Supplement>> fetchSupplements({
    int page = 0,
    List<String>? selectedTags,
    String? query,
  }) async {
    await Future<void>.delayed(simulatedDelay);

    Iterable<Supplement> results = _supplements;

    if (selectedTags != null && selectedTags.isNotEmpty) {
      results = results.where(
        (s) => selectedTags.any((tag) => s.tags.contains(tag)),
      );
    }

    if (query != null && query.trim().isNotEmpty) {
      final lower = query.toLowerCase();
      results = results.where(
        (s) =>
            s.name.toLowerCase().contains(lower) ||
            s.description.toLowerCase().contains(lower) ||
            s.benefits.any((b) => b.toLowerCase().contains(lower)),
      );
    }

    final start = page * pageSize;
    final end = start + pageSize;
    final list = results.toList();
    if (start >= list.length) {
      return <Supplement>[];
    }
    final safeEnd = end.clamp(0, list.length).toInt();
    return list.sublist(start, safeEnd);
  }

  Supplement? getById(String id) {
    for (final supplement in _supplements) {
      if (supplement.id == id) {
        return supplement;
      }
    }
    return null;
  }

  List<Supplement> featured() {
    return _supplements.take(4).toList();
  }
}
