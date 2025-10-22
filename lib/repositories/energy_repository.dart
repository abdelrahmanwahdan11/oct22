import 'dart:async';

import 'package:smart_home_control/data/mock_data.dart';
import 'package:smart_home_control/models/energy_point.dart';

class EnergyRepository {
  Future<List<EnergyPoint>> fetchMonthly() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(MockData.energy);
  }
}
