class StoreProduct {
  const StoreProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.image,
    required this.tags,
    required this.rating,
    required this.reviewsCount,
    required this.isBestSeller,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String image;
  final List<String> tags;
  final double rating;
  final int reviewsCount;
  final bool isBestSeller;
}
