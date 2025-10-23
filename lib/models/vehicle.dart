import 'package:flutter/material.dart';

import 'compartment.dart';

@immutable
class Vehicle {
  const Vehicle({
    required this.vin,
    required this.name,
    required this.capacityLb,
    required this.currentLb,
    required this.miles,
    required this.compartments,
  });

  final String vin;
  final String name;
  final int capacityLb;
  final int currentLb;
  final int miles;
  final List<Compartment> compartments;

  Vehicle copyWith({
    String? vin,
    String? name,
    int? capacityLb,
    int? currentLb,
    int? miles,
    List<Compartment>? compartments,
  }) {
    return Vehicle(
      vin: vin ?? this.vin,
      name: name ?? this.name,
      capacityLb: capacityLb ?? this.capacityLb,
      currentLb: currentLb ?? this.currentLb,
      miles: miles ?? this.miles,
      compartments: compartments ?? List<Compartment>.from(this.compartments),
    );
  }
}
