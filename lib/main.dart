import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/feature_controller.dart';
import 'controllers/pass_controller.dart';
import 'controllers/plan_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/store_controller.dart';
import 'controllers/supplements_controller.dart';
import 'controllers/trainer_controller.dart';
import 'data/repositories/plan_repository.dart';
import 'data/repositories/prefs_repository.dart';
import 'data/repositories/progress_repository.dart';
import 'data/repositories/store_repository.dart';
import 'data/repositories/supplements_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/feature_repository.dart';
import 'data/repositories/pass_repository.dart';
import 'data/repositories/trainer_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefsRepository = PrefsRepository();
  await prefsRepository.init();

  final supplementsRepository = SupplementsRepository(pageSize: 12);
  final planRepository = PlanRepository();
  final progressRepository = ProgressRepository();
  final userRepository = UserRepository();
  final trainerRepository = TrainerRepository();
  final storeRepository = StoreRepository();
  final featureRepository = FeatureRepository();
  final passRepository = PassRepository();

  final settingsController = SettingsController(prefsRepository);
  await settingsController.load();

  final supplementsController =
      SupplementsController(supplementsRepository, prefsRepository);
  await supplementsController.init();

  final planController =
      PlanController(planRepository, progressRepository, supplementsRepository);
  await planController.load();

  final trainerController = TrainerController(trainerRepository);
  await trainerController.load();

  final storeController = StoreController(storeRepository);
  await storeController.load();

  final featureController = FeatureController(featureRepository);
  await featureController.load();

  final passController = PassController(passRepository);
  await passController.load();

  runApp(
    LumaApp(
      settingsController: settingsController,
      supplementsController: supplementsController,
      planController: planController,
      userRepository: userRepository,
      trainerController: trainerController,
      storeController: storeController,
      featureController: featureController,
      passController: passController,
    ),
  );
}
