import 'package:flutter/material.dart';
import 'package:smart_home_control/app.dart';
import 'package:smart_home_control/controllers/access_controller.dart';
import 'package:smart_home_control/controllers/devices_controller.dart';
import 'package:smart_home_control/controllers/energy_controller.dart';
import 'package:smart_home_control/controllers/rooms_controller.dart';
import 'package:smart_home_control/controllers/settings_controller.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/repositories/devices_repository.dart';
import 'package:smart_home_control/repositories/energy_repository.dart';
import 'package:smart_home_control/repositories/rooms_repository.dart';
import 'package:smart_home_control/repositories/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localization = await AppLocalizations.loadFromPrefs();
  final settingsRepository = SettingsRepository();
  final settingsController = SettingsController(settingsRepository, localization);
  await settingsController.load();

  final roomsController = RoomsController(RoomsRepository());
  await roomsController.load();

  final devicesRepository = DevicesRepository();
  final devicesController = DevicesController(devicesRepository, settingsRepository);
  await devicesController.load();

  final energyController = EnergyController(EnergyRepository());
  await energyController.load();

  final accessController = AccessController(settingsRepository);
  await accessController.load();

  runApp(SmartHomeApp(
    roomsController: roomsController,
    devicesController: devicesController,
    energyController: energyController,
    accessController: accessController,
    settingsController: settingsController,
    localization: localization,
  ));
}
