import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/plan_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/supplements_controller.dart';
import 'data/repositories/plan_repository.dart';
import 'data/repositories/prefs_repository.dart';
import 'data/repositories/progress_repository.dart';
import 'data/repositories/supplements_repository.dart';
import 'data/repositories/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefsRepository = PrefsRepository();
  await prefsRepository.init();

  final supplementsRepository = SupplementsRepository(pageSize: 12);
  final planRepository = PlanRepository();
  final progressRepository = ProgressRepository();
  final userRepository = UserRepository();

  final settingsController = SettingsController(prefsRepository);
  await settingsController.load();

  final supplementsController =
      SupplementsController(supplementsRepository, prefsRepository);
  await supplementsController.init();

  final planController =
      PlanController(planRepository, progressRepository, supplementsRepository);
  await planController.load();

  runApp(
    LumaApp(
      settingsController: settingsController,
      supplementsController: supplementsController,
      planController: planController,
      userRepository: userRepository,
    ),
  );
}
