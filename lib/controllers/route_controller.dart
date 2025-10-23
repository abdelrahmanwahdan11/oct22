import 'package:flutter/material.dart';

import '../models/models.dart';
import '../repositories/route_repository.dart';
import 'vehicle_controller.dart';

class RouteController extends ChangeNotifier {
  RouteController(this._repository);

  final RouteRepository _repository;

  RoutePlan? _plan;
  List<SchedulePoint> _schedule = const [];
  List<ChartPoint> _optimizationPoints = const [];
  VehicleController? _vehicleController;

  RoutePlan? get plan => _plan;
  List<Stop> get stops => _plan?.stops ?? const [];
  List<SchedulePoint> get schedule => _schedule;
  List<ChartPoint> get optimizationPoints => _optimizationPoints;

  int get totalWeight => stops.fold<int>(0, (value, stop) => value + stop.weightLb);
  int get totalPallets => stops.fold<int>(0, (value, stop) => value + stop.pallets);

  Future<void> load() async {
    _plan = await _repository.fetchRoutePlan();
    _schedule = await _repository.fetchSchedule();
    _optimizationPoints = await _repository.fetchOptimizationPoints();
    _recalculateTotals();
    notifyListeners();
  }

  void attachVehicleController(VehicleController controller) {
    _vehicleController = controller;
    _recalculateTotals();
  }

  void toggleStopSelection(String stopId) {
    if (_plan == null) {
      return;
    }
    final stops = List<Stop>.from(_plan!.stops);
    final index = stops.indexWhere((stop) => stop.id == stopId);
    if (index == -1) {
      return;
    }
    final stop = stops[index];
    stops[index] = stop.copyWith(selected: !stop.selected);
    _plan = _plan!.copyWith(stops: stops);
    notifyListeners();
  }

  void reorderStops(int oldIndex, int newIndex) {
    if (_plan == null) {
      return;
    }
    final stops = List<Stop>.from(_plan!.stops);
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = stops.removeAt(oldIndex);
    stops.insert(newIndex, item);
    _plan = _plan!.copyWith(stops: stops);
    _recalculateTotals();
    notifyListeners();
  }

  void sortByWeight() {
    if (_plan == null) {
      return;
    }
    final stops = List<Stop>.from(_plan!.stops)
      ..sort((a, b) => a.weightLb.compareTo(b.weightLb));
    _plan = _plan!.copyWith(stops: stops);
    notifyListeners();
  }

  void sortByPallets() {
    if (_plan == null) {
      return;
    }
    final stops = List<Stop>.from(_plan!.stops)
      ..sort((a, b) => a.pallets.compareTo(b.pallets));
    _plan = _plan!.copyWith(stops: stops);
    notifyListeners();
  }

  void assignStopToCompartment(String stopId, String compartmentId) {
    final plan = _plan;
    final vehicleController = _vehicleController;
    if (plan == null || vehicleController == null) {
      return;
    }
    final stops = List<Stop>.from(plan.stops);
    final index = stops.indexWhere((stop) => stop.id == stopId);
    if (index == -1) {
      return;
    }
    final current = stops[index];
    stops[index] = current.copyWith(lockedToCompartmentId: compartmentId);
    _plan = plan.copyWith(stops: stops);
    vehicleController.assignStop(
      stopId: current.id,
      weightLb: current.weightLb,
      fromCompartmentId: current.lockedToCompartmentId,
      toCompartmentId: compartmentId,
    );
    _recalculateTotals();
    notifyListeners();
  }

  void autoAssignStops() {
    final vehicleController = _vehicleController;
    final plan = _plan;
    if (vehicleController == null || plan == null) {
      return;
    }
    final orderedStops = List<Stop>.from(plan.stops)
      ..sort((a, b) => a.weightLb.compareTo(b.weightLb));
    for (final stop in orderedStops) {
      final target = _findBestCompartment(vehicleController);
      if (target != null) {
        assignStopToCompartment(stop.id, target.id);
      }
    }
  }

  Compartment? _findBestCompartment(VehicleController vehicleController) {
    var bestCompartment = vehicleController.compartments.isEmpty
        ? null
        : vehicleController.compartments.first;
    int bestRemaining = -1;
    for (final compartment in vehicleController.compartments) {
      final remaining = compartment.capacityLb - compartment.currentLb;
      if (remaining > bestRemaining) {
        bestRemaining = remaining;
        bestCompartment = compartment;
      }
    }
    return bestCompartment;
  }

  void _recalculateTotals() {
    final plan = _plan;
    final vehicleController = _vehicleController;
    if (plan == null || vehicleController == null) {
      return;
    }
    final totalWeight = plan.stops.fold<int>(0, (value, stop) => value + stop.weightLb);
    _plan = plan.copyWith(weightLb: totalWeight);
    vehicleController.updateCurrentWeight(totalWeight);
  }
}
