import 'package:flutter/material.dart';

@immutable
class Compartment {
  const Compartment({
    required this.id,
    required this.label,
    required this.capacityLb,
    required this.currentLb,
    required this.color,
    required this.items,
  });

  final String id;
  final String label;
  final int capacityLb;
  final int currentLb;
  final Color color;
  final List<String> items;

  double get utilization => capacityLb == 0 ? 0 : currentLb / capacityLb;

  Compartment copyWith({
    String? id,
    String? label,
    int? capacityLb,
    int? currentLb,
    Color? color,
    List<String>? items,
  }) {
    return Compartment(
      id: id ?? this.id,
      label: label ?? this.label,
      capacityLb: capacityLb ?? this.capacityLb,
      currentLb: currentLb ?? this.currentLb,
      color: color ?? this.color,
      items: items ?? List<String>.from(this.items),
    );
  }
}
