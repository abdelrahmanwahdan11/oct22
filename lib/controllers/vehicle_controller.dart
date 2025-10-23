import 'package:flutter/material.dart';

import '../models/models.dart';
import '../repositories/vehicle_repository.dart';

class VehicleController extends ChangeNotifier {
  VehicleController(this._repository);

  final VehicleRepository _repository;

  Vehicle? _vehicle;

  Vehicle? get vehicle => _vehicle;
  List<Compartment> get compartments => _vehicle?.compartments ?? const <Compartment>[];

  int get remainingCapacity {
    if (_vehicle == null) {
      return 0;
    }
    final used = compartments.fold<int>(0, (value, element) => value + element.currentLb);
    return _vehicle!.capacityLb - used;
  }

  Future<void> load() async {
    _vehicle = await _repository.fetchVehicle();
    notifyListeners();
  }

  void updateCurrentWeight(int weightLb) {
    if (_vehicle == null) {
      return;
    }
    _vehicle = _vehicle!.copyWith(currentLb: weightLb);
    notifyListeners();
  }

  void assignStop({
    required String stopId,
    required int weightLb,
    String? fromCompartmentId,
    required String toCompartmentId,
  }) {
    if (_vehicle == null) {
      return;
    }
    final updatedCompartments = <Compartment>[];
    for (final compartment in compartments) {
      if (compartment.id == fromCompartmentId && fromCompartmentId != toCompartmentId) {
        final newItems = List<String>.from(compartment.items)..remove(stopId);
        final newWeight = (compartment.currentLb - weightLb).clamp(0, compartment.capacityLb).toInt();
        updatedCompartments.add(
          compartment.copyWith(
            currentLb: newWeight,
            items: newItems,
          ),
        );
      } else if (compartment.id == toCompartmentId) {
        final newItems = List<String>.from(compartment.items);
        if (!newItems.contains(stopId)) {
          newItems.add(stopId);
        }
        final weightDelta = fromCompartmentId == toCompartmentId ? 0 : weightLb;
        final updatedWeight = (compartment.currentLb + weightDelta).clamp(0, compartment.capacityLb).toInt();
        updatedCompartments.add(
          compartment.copyWith(
            currentLb: updatedWeight,
            items: newItems,
          ),
        );
      } else {
        updatedCompartments.add(compartment);
      }
    }

    _updateCompartments(updatedCompartments);
  }

  void removeStopAssignment({
    required String stopId,
    required int weightLb,
    String? fromCompartmentId,
  }) {
    if (_vehicle == null || fromCompartmentId == null) {
      return;
    }
    final updatedCompartments = <Compartment>[];
    for (final compartment in compartments) {
      if (compartment.id == fromCompartmentId) {
        final newItems = List<String>.from(compartment.items)..remove(stopId);
        final updatedWeight = (compartment.currentLb - weightLb).clamp(0, compartment.capacityLb).toInt();
        updatedCompartments.add(
          compartment.copyWith(
            currentLb: updatedWeight,
            items: newItems,
          ),
        );
      } else {
        updatedCompartments.add(compartment);
      }
    }
    _updateCompartments(updatedCompartments);
  }

  String? labelForCompartment(String? id) {
    if (id == null) {
      return null;
    }
    for (final compartment in compartments) {
      if (compartment.id == id) {
        return compartment.label;
      }
    }
    return null;
  }

  void _updateCompartments(List<Compartment> updatedCompartments) {
    if (_vehicle == null) {
      return;
    }
    _vehicle = _vehicle!.copyWith(compartments: updatedCompartments);
    final totalWeight = updatedCompartments.fold<int>(0, (value, element) => value + element.currentLb);
    _vehicle = _vehicle!.copyWith(currentLb: totalWeight);
    notifyListeners();
  }
}
