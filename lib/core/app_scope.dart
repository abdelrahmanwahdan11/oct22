import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/route_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/vehicle_controller.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required super.child,
    required this.routeController,
    required this.vehicleController,
    required this.settingsController,
    required this.authController,
  });

  final RouteController routeController;
  final VehicleController vehicleController;
  final SettingsController settingsController;
  final AuthController authController;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return routeController != oldWidget.routeController ||
        vehicleController != oldWidget.vehicleController ||
        settingsController != oldWidget.settingsController ||
        authController != oldWidget.authController;
  }
}
