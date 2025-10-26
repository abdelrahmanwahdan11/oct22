import 'package:flutter/material.dart';

class FitnessClub {
  const FitnessClub({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.contactNumber,
    required this.discount,
    required this.image,
    required this.features,
    required this.mapUrl,
  });

  final String id;
  final String name;
  final String address;
  final String city;
  final String contactNumber;
  final String discount;
  final String image;
  final List<String> features;
  final String mapUrl;

  Color accentColor() {
    final hash = id.hashCode;
    final colors = [
      const Color(0xFF4AC6A8),
      const Color(0xFF9DD36A),
      const Color(0xFFF59E0B),
      const Color(0xFF49D2B1),
      const Color(0xFFEF4444),
    ];
    return colors[hash.abs() % colors.length];
  }
}
