import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/access_controller.dart';
import 'package:smart_home_control/controllers/auth_controller.dart';
import 'package:smart_home_control/controllers/devices_controller.dart';
import 'package:smart_home_control/controllers/energy_controller.dart';
import 'package:smart_home_control/controllers/rooms_controller.dart';
import 'package:smart_home_control/controllers/settings_controller.dart';

class ControllerScope extends InheritedWidget {
  const ControllerScope({
    super.key,
    required super.child,
    required this.rooms,
    required this.devices,
    required this.energy,
    required this.access,
    required this.settings,
    required this.auth,
  });

  final RoomsController rooms;
  final DevicesController devices;
  final EnergyController energy;
  final AccessController access;
  final SettingsController settings;
  final AuthController auth;

  static ControllerScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ControllerScope>();
    assert(scope != null, 'ControllerScope is missing in the widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant ControllerScope oldWidget) {
    return rooms != oldWidget.rooms ||
        devices != oldWidget.devices ||
        energy != oldWidget.energy ||
        access != oldWidget.access ||
        settings != oldWidget.settings ||
        auth != oldWidget.auth;
  }
}
