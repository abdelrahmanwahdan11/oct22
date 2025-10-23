import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/route_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/vehicle_controller.dart';
import 'repositories/auth_repository.dart';
import 'repositories/route_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/vehicle_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsRepository = SettingsRepository();
  final settingsController = SettingsController(settingsRepository);
  await settingsController.load();

  final authRepository = AuthRepository();
  final authController = AuthController(authRepository);
  await authController.load();

  final vehicleController = VehicleController(const VehicleRepository());
  await vehicleController.load();

  final routeController = RouteController(const RouteRepository());
  routeController.attachVehicleController(vehicleController);
  await routeController.load();

  runApp(
    FleetPlannerApp(
      routeController: routeController,
      vehicleController: vehicleController,
      settingsController: settingsController,
      authController: authController,
    ),
  );
}
