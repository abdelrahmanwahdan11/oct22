import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeatureIdea {
  const FeatureIdea({
    required this.id,
    required this.category,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.icon,
  });

  final String id;
  final String category;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final IconData icon;

  String title(String languageCode) =>
      languageCode == 'ar' ? titleAr : titleEn;

  String description(String languageCode) =>
      languageCode == 'ar' ? descriptionAr : descriptionEn;
}
