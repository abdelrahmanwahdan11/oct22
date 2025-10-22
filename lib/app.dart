import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_home_control/controllers/access_controller.dart';
import 'package:smart_home_control/controllers/devices_controller.dart';
import 'package:smart_home_control/controllers/energy_controller.dart';
import 'package:smart_home_control/controllers/rooms_controller.dart';
import 'package:smart_home_control/controllers/settings_controller.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/core/app_router.dart';
import 'package:smart_home_control/core/app_theme.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/screens/home/home_shell.dart';

class SmartHomeApp extends StatefulWidget {
  const SmartHomeApp({
    super.key,
    required this.roomsController,
    required this.devicesController,
    required this.energyController,
    required this.accessController,
    required this.settingsController,
    required this.localization,
  });

  final RoomsController roomsController;
  final DevicesController devicesController;
  final EnergyController energyController;
  final AccessController accessController;
  final SettingsController settingsController;
  final AppLocalizations localization;

  @override
  State<SmartHomeApp> createState() => _SmartHomeAppState();
}

class _SmartHomeAppState extends State<SmartHomeApp> {
  late final Listenable _listenable;

  @override
  void initState() {
    super.initState();
    _listenable = Listenable.merge([
      widget.settingsController,
      widget.localization,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _listenable,
      builder: (context, _) {
        final locale = widget.localization.locale;
        return ControllerScope(
          rooms: widget.roomsController,
          devices: widget.devicesController,
          energy: widget.energyController,
          access: widget.accessController,
          settings: widget.settingsController,
          child: MaterialApp(
            title: 'Smart Home Control',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(Brightness.light),
            darkTheme: buildAppTheme(Brightness.dark),
            themeMode: widget.settingsController.themeMode,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return Directionality(
                textDirection: _directionFor(locale),
                child: MediaQuery(
                  data: mediaQuery.copyWith(textScaler: mediaQuery.textScaler),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
            onGenerateRoute: AppRouter.onGenerateRoute,
            home: const HomeShell(),
          ),
        );
      },
    );
  }

  TextDirection _directionFor(Locale locale) {
    return locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}
