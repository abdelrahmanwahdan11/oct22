import 'package:flutter/material.dart';

@immutable
class SchedulePoint {
  const SchedulePoint({
    required this.time,
    required this.label,
    required this.deltaMin,
    required this.color,
  });

  final String time;
  final String label;
  final int deltaMin;
  final Color color;
}

@immutable
class EnergyPoint {
  const EnergyPoint({
    required this.hour,
    required this.gain,
    required this.orders,
  });

  final int hour;
  final double gain;
  final int orders;
}

@immutable
class ChartPoint {
  const ChartPoint({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;
}
