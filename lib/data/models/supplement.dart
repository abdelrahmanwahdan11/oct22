class Supplement {
  const Supplement({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.tags,
    required this.description,
    required this.benefits,
    required this.dosage,
    required this.schedule,
    required this.rating,
  });

  final String id;
  final String name;
  final String image;
  final String category;
  final List<String> tags;
  final String description;
  final List<String> benefits;
  final String dosage;
  final String schedule;
  final double rating;
}
