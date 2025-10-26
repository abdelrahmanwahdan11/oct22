import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/plan_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/supplements_controller.dart';
import 'core/localization/app_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_scope.dart';
import 'data/repositories/user_repository.dart';

class LumaApp extends StatelessWidget {
  const LumaApp({
    super.key,
    required this.settingsController,
    required this.supplementsController,
    required this.planController,
    required this.userRepository,
  });

  final SettingsController settingsController;
  final SupplementsController supplementsController;
  final PlanController planController;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        return Directionality(
          textDirection: settingsController.locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: AppScope(
            settingsController: settingsController,
            supplementsController: supplementsController,
            planController: planController,
            userRepository: userRepository,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Luma+ Wellness',
              locale: settingsController.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: AppTheme.buildLightTheme(),
              darkTheme: AppTheme.buildDarkTheme(),
              themeMode: settingsController.themeMode,
              initialRoute: settingsController.onboardingDone
                  ? AppRoutes.dashboard
                  : AppRoutes.onboarding,
              onGenerateRoute: onGenerateRoute,
            ),
          ),
        );
      },
    );
  }
}
