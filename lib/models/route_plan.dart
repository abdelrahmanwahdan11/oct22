import 'package:flutter/material.dart';

import 'stop.dart';

@immutable
class RoutePlan {
  const RoutePlan({
    required this.id,
    required this.vehicleVin,
    required this.date,
    required this.stops,
    required this.distanceMi,
    required this.weightLb,
    required this.status,
  });

  final String id;
  final String vehicleVin;
  final DateTime date;
  final List<Stop> stops;
  final int distanceMi;
  final int weightLb;
  final String status;

  RoutePlan copyWith({
    String? id,
    String? vehicleVin,
    DateTime? date,
    List<Stop>? stops,
    int? distanceMi,
    int? weightLb,
    String? status,
  }) {
    return RoutePlan(
      id: id ?? this.id,
      vehicleVin: vehicleVin ?? this.vehicleVin,
      date: date ?? this.date,
      stops: stops ?? List<Stop>.from(this.stops),
      distanceMi: distanceMi ?? this.distanceMi,
      weightLb: weightLb ?? this.weightLb,
      status: status ?? this.status,
    );
  }
}
