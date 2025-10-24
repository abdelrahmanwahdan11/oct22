import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/auth_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/filters_controller.dart';
import 'controllers/properties_controller.dart';
import 'controllers/settings_controller.dart';
import 'core/localization/app_localizations.dart';
import 'core/providers/notifier_provider.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/agents_repository.dart';

class RealEstateApp extends StatefulWidget {
  const RealEstateApp({
    super.key,
    required this.settingsController,
    required this.authController,
    required this.favoritesController,
    required this.filtersController,
    required this.propertiesController,
    required this.agentsRepository,
  });

  final SettingsController settingsController;
  final AuthController authController;
  final FavoritesController favoritesController;
  final FiltersController filtersController;
  final PropertiesController propertiesController;
  final AgentsRepository agentsRepository;

  @override
  State<RealEstateApp> createState() => _RealEstateAppState();
}

class _RealEstateAppState extends State<RealEstateApp> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(agentsRepository: widget.agentsRepository);
  }

  @override
  Widget build(BuildContext context) {
    return NotifierProvider<SettingsController>(
      notifier: widget.settingsController,
      child: NotifierProvider<AuthController>(
        notifier: widget.authController,
        child: NotifierProvider<FavoritesController>(
          notifier: widget.favoritesController,
          child: NotifierProvider<FiltersController>(
            notifier: widget.filtersController,
            child: NotifierProvider<PropertiesController>(
              notifier: widget.propertiesController,
              child: Builder(builder: (context) {
                final settings = NotifierProvider.of<SettingsController>(context);
                return MaterialApp( 
                  debugShowCheckedModeBanner: false,
                  title: 'RealEstate+',
                  theme: AppTheme.light(),
                  darkTheme: AppTheme.dark(),
                  themeMode: settings.themeMode,
                  locale: settings.locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (locale, supported) {
                    if (locale == null) return AppLocalizations.defaultLocale;
                    for (final supportedLocale in supported) {
                      if (supportedLocale.languageCode == locale.languageCode) {
                        return supportedLocale;
                      }
                    }
                    return AppLocalizations.defaultLocale;
                  },
                  initialRoute:
                      settings.onboardingComplete ? 'auth.login' : 'onboarding',
                  onGenerateRoute: _router.onGenerateRoute,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
