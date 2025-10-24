import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/filters_controller.dart';
import 'controllers/properties_controller.dart';
import 'controllers/settings_controller.dart';
import 'data/repositories/agents_repository.dart';
import 'data/repositories/prefs_repository.dart';
import 'data/repositories/properties_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefsRepository = PrefsRepository();
  final agentsRepository = AgentsRepository();
  final propertiesRepository = PropertiesRepository();

  final settingsController = SettingsController(prefsRepository);
  await settingsController.load();

  final filtersController = FiltersController(prefsRepository);
  await filtersController.load();

  final favoritesController = FavoritesController(prefsRepository, propertiesRepository);
  await favoritesController.load();

  final propertiesController = PropertiesController(
    propertiesRepository,
    filtersController,
    favoritesController,
  );
  await propertiesController.loadInitial();

  final authController = AuthController();

  runApp(
    RealEstateApp(
      settingsController: settingsController,
      authController: authController,
      favoritesController: favoritesController,
      filtersController: filtersController,
      propertiesController: propertiesController,
      agentsRepository: agentsRepository,
    ),
  );
}
