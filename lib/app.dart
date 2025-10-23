import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/auth_controller.dart';
import 'controllers/route_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/vehicle_controller.dart';
import 'core/app_scope.dart';
import 'core/app_theme.dart';
import 'core/navigation.dart';
import 'l10n/app_localizations.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/distribution_screen.dart';
import 'screens/map_optimization_screen.dart';
import 'screens/planning_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/timeline_cockpit_screen.dart';

class FleetPlannerApp extends StatelessWidget {
  const FleetPlannerApp({
    super.key,
    required this.routeController,
    required this.vehicleController,
    required this.settingsController,
    required this.authController,
  });

  final RouteController routeController;
  final VehicleController vehicleController;
  final SettingsController settingsController;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([settingsController, authController]),
      builder: (context, _) {
        final initialRoute = _resolveInitialRoute();
        return AppScope(
          routeController: routeController,
          vehicleController: vehicleController,
          settingsController: settingsController,
          authController: authController,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Fleet Planner',
            theme: buildAppTheme(ThemeSetting.light),
            darkTheme: buildAppTheme(ThemeSetting.dark),
            themeMode: settingsController.themeMode,
            locale: settingsController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              },
            ),
            initialRoute: initialRoute,
            onGenerateRoute: _onGenerateRoute,
            builder: (context, child) {
              final localization = AppLocalizations.of(context);
              final direction = localization.isRtl ? TextDirection.rtl : TextDirection.ltr;
              return Directionality(
                textDirection: direction,
                child: child ?? const SizedBox.shrink(),
              );
            },
          ),
        );
      },
    );
  }

  String _resolveInitialRoute() {
    if (!authController.completedOnboarding) {
      return AppNavigation.routes['onboarding']!;
    }
    if (!authController.isAuthenticated) {
      return AppNavigation.routes['auth.login']!;
    }
    return AppNavigation.routes['planning']!;
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final name = settings.name;
    Widget page;
    switch (name) {
      case '/onboarding':
        page = OnboardingScreen(authController: authController);
        break;
      case '/auth/login':
        page = LoginScreen(authController: authController);
        break;
      case '/auth/register':
        page = RegisterScreen(authController: authController);
        break;
      case '/planning':
        page = PlanningScreen(
          routeController: routeController,
          vehicleController: vehicleController,
        );
        break;
      case '/distribution':
        page = DistributionScreen(
          routeController: routeController,
          vehicleController: vehicleController,
        );
        break;
      case '/statistics':
        page = StatisticsScreen(
          routeController: routeController,
          vehicleController: vehicleController,
        );
        break;
      case '/timeline.cockpit':
        page = TimelineCockpitScreen(routeController: routeController);
        break;
      case '/map.optimization':
        page = MapOptimizationScreen(routeController: routeController);
        break;
      case '/settings':
        page = SettingsScreen(settingsController: settingsController);
        break;
      default:
        page = PlanningScreen(
          routeController: routeController,
          vehicleController: vehicleController,
        );
        break;
    }
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.08, 0.02),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        final fadeAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }
}
