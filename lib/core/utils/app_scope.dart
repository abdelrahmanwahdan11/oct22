import 'package:flutter/widgets.dart';

import '../../controllers/feature_controller.dart';
import '../../controllers/pass_controller.dart';
import '../../controllers/plan_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/store_controller.dart';
import '../../controllers/supplements_controller.dart';
import '../../controllers/trainer_controller.dart';
import '../../data/repositories/user_repository.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required super.child,
    required this.settingsController,
    required this.supplementsController,
    required this.planController,
    required this.userRepository,
    required this.trainerController,
    required this.storeController,
    required this.featureController,
    required this.passController,
  });

  final SettingsController settingsController;
  final SupplementsController supplementsController;
  final PlanController planController;
  final UserRepository userRepository;
  final TrainerController trainerController;
  final StoreController storeController;
  final FeatureController featureController;
  final PassController passController;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return settingsController != oldWidget.settingsController ||
        supplementsController != oldWidget.supplementsController ||
        planController != oldWidget.planController ||
        userRepository != oldWidget.userRepository ||
        trainerController != oldWidget.trainerController ||
        storeController != oldWidget.storeController ||
        featureController != oldWidget.featureController ||
        passController != oldWidget.passController;
  }
}
