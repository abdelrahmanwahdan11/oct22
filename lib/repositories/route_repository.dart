import 'dart:async';

import 'package:flutter/material.dart';

import '../models/models.dart';

class RouteRepository {
  const RouteRepository();

  Future<RoutePlan> fetchRoutePlan() async {
    await Future.delayed(const Duration(milliseconds: 320));
    final stops = <Stop>[
      const Stop(
        id: 's1',
        code: '237325623',
        address: '2464 Royal Ln, Mesa',
        pallets: 3,
        weightLb: 1040,
        eta: '06:45',
        selected: true,
      ),
      const Stop(
        id: 's2',
        code: '837726633',
        address: '3517 W. Gray St, Utica',
        pallets: 1,
        weightLb: 1340,
        eta: '08:10',
        selected: true,
      ),
      const Stop(
        id: 's3',
        code: '876354523',
        address: '6391 Elgin St, Celina',
        pallets: 6,
        weightLb: 3127,
        eta: '09:37',
        selected: false,
      ),
    ];
    return RoutePlan(
      id: 'rp1',
      vehicleVin: 'SND7763625',
      date: DateTime(2025, 12, 20),
      stops: stops,
      distanceMi: 1260,
      weightLb: 7640,
      status: 'draft',
    );
  }

  Future<List<SchedulePoint>> fetchSchedule() async {
    await Future.delayed(const Duration(milliseconds: 180));
    return const [
      SchedulePoint(time: '14:00', label: 'Load', deltaMin: 0, color: Color(0xFF6B8AFD)),
      SchedulePoint(time: '18:00', label: 'Drive', deltaMin: 120, color: Color(0xFF3DC17A)),
      SchedulePoint(time: '21:32', label: 'Stop', deltaMin: 30, color: Color(0xFFF5A524)),
      SchedulePoint(time: '22:00', label: 'Unload', deltaMin: 60, color: Color(0xFF6B8AFD)),
    ];
  }

  Future<List<ChartPoint>> fetchOptimizationPoints() async {
    await Future.delayed(const Duration(milliseconds: 140));
    return const [
      ChartPoint(x: 20.0, y: 12),
      ChartPoint(x: 21.0, y: 18),
      ChartPoint(x: 22.0, y: 29),
      ChartPoint(x: 23.0, y: 22),
    ];
  }
}
