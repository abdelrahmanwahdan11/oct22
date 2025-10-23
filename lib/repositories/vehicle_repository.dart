import 'dart:async';

import 'package:flutter/material.dart';

import '../models/models.dart';

class VehicleRepository {
  const VehicleRepository();

  Future<Vehicle> fetchVehicle() async {
    await Future.delayed(const Duration(milliseconds: 260));
    return Vehicle(
      vin: 'SND7763625',
      name: 'UTD38723',
      capacityLb: 11800,
      currentLb: 7640,
      miles: 1260,
      compartments: const [
        Compartment(
          id: 'c1',
          label: 'A',
          capacityLb: 4000,
          currentLb: 2600,
          color: Color(0xFFE8FF66),
          items: <String>[],
        ),
        Compartment(
          id: 'c2',
          label: 'B',
          capacityLb: 4000,
          currentLb: 2800,
          color: Color(0xFFE8FF66),
          items: <String>[],
        ),
        Compartment(
          id: 'c3',
          label: 'C',
          capacityLb: 3800,
          currentLb: 2240,
          color: Color(0xFFE8FF66),
          items: <String>[],
        ),
      ],
    );
  }
}
