import 'package:flutter/material.dart';

@immutable
class RouteSummary {
  const RouteSummary({
    required this.id,
    required this.title,
    required this.date,
    required this.distanceMi,
    required this.weightLb,
    required this.status,
    required this.onTimeRate,
    required this.stops,
    this.isActive = false,
  });

  final String id;
  final String title;
  final DateTime date;
  final int distanceMi;
  final int weightLb;
  final String status;
  final double onTimeRate;
  final int stops;
  final bool isActive;

  RouteSummary copyWith({
    String? id,
    String? title,
    DateTime? date,
    int? distanceMi,
    int? weightLb,
    String? status,
    double? onTimeRate,
    int? stops,
    bool? isActive,
  }) {
    return RouteSummary(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      distanceMi: distanceMi ?? this.distanceMi,
      weightLb: weightLb ?? this.weightLb,
      status: status ?? this.status,
      onTimeRate: onTimeRate ?? this.onTimeRate,
      stops: stops ?? this.stops,
      isActive: isActive ?? this.isActive,
    );
  }
}
