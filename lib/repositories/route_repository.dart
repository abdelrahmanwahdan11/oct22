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

  Future<List<RouteSummary>> fetchRouteHistory() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      RouteSummary(
        id: 'h1',
        title: 'PB-LP-PB Scenario',
        date: DateTime(2025, 12, 18),
        distanceMi: 940,
        weightLb: 6240,
        status: 'completed',
        onTimeRate: 0.92,
        stops: 8,
        isActive: true,
      ),
      RouteSummary(
        id: 'h2',
        title: 'Mesa Night Run',
        date: DateTime(2025, 12, 12),
        distanceMi: 1080,
        weightLb: 7820,
        status: 'completed',
        onTimeRate: 0.87,
        stops: 10,
      ),
      RouteSummary(
        id: 'h3',
        title: 'Utica Express',
        date: DateTime(2025, 12, 4),
        distanceMi: 860,
        weightLb: 6980,
        status: 'delayed',
        onTimeRate: 0.74,
        stops: 6,
      ),
    ];
  }

  Future<List<Stop>> fetchSuggestedStops() async {
    await Future.delayed(const Duration(milliseconds: 220));
    return const [
      Stop(
        id: 'ns1',
        code: '555883221',
        address: '4886 Main St, Plano',
        pallets: 2,
        weightLb: 640,
        eta: '11:10',
        selected: false,
      ),
      Stop(
        id: 'ns2',
        code: '441230198',
        address: '7129 Prospect Ave, Dallas',
        pallets: 4,
        weightLb: 1890,
        eta: '12:35',
        selected: true,
      ),
      Stop(
        id: 'ns3',
        code: '126983450',
        address: '3231 Hill Rd, Phoenix',
        pallets: 1,
        weightLb: 420,
        eta: '14:20',
        selected: false,
      ),
    ];
  }
}
