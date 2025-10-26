import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/discover/discover_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/plan/plan_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/supplement/supplement_details_screen.dart';
import '../../screens/survey/survey_screen.dart';

class AppRoutes {
  static const onboarding = 'onboarding';
  static const login = 'auth.login';
  static const register = 'auth.register';
  static const forgot = 'auth.forgot';
  static const dashboard = 'home.dashboard';
  static const discover = 'discover.for_you';
  static const supplementDetails = 'supplement.details';
  static const survey = 'survey.monthly';
  static const planToday = 'plan.today';
  static const profile = 'profile';
  static const settings = 'settings';
  static const reminderSheet = 'reminder.sheet';
  static const filtersSheet = 'filters.sheet';
  static const search = 'search';
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.onboarding:
      return _buildPage(settings, const OnboardingScreen());
    case AppRoutes.login:
      return _buildPage(settings, const LoginScreen());
    case AppRoutes.dashboard:
      return _buildPage(settings, const HomeScreen());
    case AppRoutes.discover:
      return _buildPage(settings, const DiscoverScreen());
    case AppRoutes.planToday:
      return _buildPage(settings, const PlanScreen());
    case AppRoutes.profile:
      return _buildPage(settings, const ProfileScreen());
    case AppRoutes.supplementDetails:
      return _buildPage(
        settings,
        SupplementDetailsScreen(
          supplementId: (settings.arguments as Map?)?['id'] as String?,
        ),
      );
    case AppRoutes.survey:
      return _buildModal(settings, const SurveyScreen());
    default:
      return _buildPage(settings, const HomeScreen());
  }
}

PageRouteBuilder<dynamic> _buildPage(RouteSettings settings, Widget child) {
  return PageRouteBuilder<dynamic>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) =>
        _AnimatedPage(animation: animation, child: child),
    transitionsBuilder: _fadeSlideTransition,
  );
}

PageRouteBuilder<dynamic> _buildModal(RouteSettings settings, Widget child) {
  return PageRouteBuilder<dynamic>(
    settings: settings,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black26,
    pageBuilder: (context, animation, secondaryAnimation) =>
        Align(alignment: Alignment.bottomCenter, child: child),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(curved);
      final fade = Tween<double>(begin: 0, end: 1).animate(curved);
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

Widget _AnimatedPage({required Animation<double> animation, required Widget child}) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, _) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.06),
        end: Offset.zero,
      ).animate(fade);
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: child,
        ),
      ).animate().fadeIn(duration: 260.ms);
    },
  );
}

Widget _fadeSlideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
  return FadeTransition(
    opacity: curved,
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
          .animate(curved),
      child: child,
    ),
  );
}
