import 'package:flutter/material.dart';

import '../../data/repositories/agents_repository.dart';
import '../../screens/account/account_screen.dart';
import '../../screens/agents/agent_details_screen.dart';
import '../../screens/agents/agents_screen.dart';
import '../../screens/auth/forgot_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/booking/booking_sheet.dart';
import '../../screens/explore/explore_screen.dart';
import '../../screens/filters/filters_sheet.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/property/property_details_screen.dart';
import '../../screens/saved/saved_screen.dart';
import '../../screens/settings/settings_screen.dart';

class AppRouter {
  AppRouter({required this.agentsRepository});

  final AgentsRepository agentsRepository;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name;
    switch (name) {
      case '/':
      case 'onboarding':
        return _defaultRoute(settings, const OnboardingScreen());
      case 'auth.login':
        return _defaultRoute(settings, const LoginScreen());
      case 'auth.register':
        return _defaultRoute(settings, const RegisterScreen());
      case 'auth.forgot':
        return _defaultRoute(settings, const ForgotPasswordScreen());
      case 'home':
        return _defaultRoute(settings, const HomeScreen());
      case 'explore':
        return _defaultRoute(settings, const ExploreScreen());
      case 'saved':
        return _defaultRoute(settings, const SavedScreen());
      case 'account':
        return _defaultRoute(settings, const AccountScreen());
      case 'settings':
        return _defaultRoute(settings, const SettingsScreen());
      case 'agents':
        return _defaultRoute(
          settings,
          AgentsScreen(repository: agentsRepository),
        );
      case 'agent.details':
        final id = settings.arguments as String?;
        if (id == null) return null;
        final agent = agentsRepository.findById(id);
        if (agent == null) return null;
        return _defaultRoute(settings, AgentDetailsScreen(agent: agent));
      case 'property.details':
        final id = settings.arguments as String?;
        if (id == null) return null;
        return _defaultRoute(settings, PropertyDetailsScreen(propertyId: id));
      case 'filters.sheet':
        return _modalRoute(settings, const FiltersSheet());
      case 'booking.sheet':
        final id = settings.arguments as String?;
        if (id == null) return null;
        return _modalRoute(settings, BookingSheet(propertyId: id));
      case 'search':
      case 'compare':
        return _defaultRoute(settings, _PlaceholderScreen(title: name ?? '')); 
      default:
        return null;
    }
  }

  PageRoute<dynamic> _defaultRoute(RouteSettings settings, Widget child) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween(begin: const Offset(0, 0.05), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut))
            .animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }

  PageRoute<dynamic> _modalRoute(RouteSettings settings, Widget child) {
    return PageRouteBuilder(
      settings: settings,
      barrierDismissible: true,
      opaque: false,
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.9,
            child: Material(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              clipBehavior: Clip.antiAlias,
              child: child,
            ),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween(begin: const Offset(0, 0.1), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut))
            .animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('Coming soon')),
    );
  }
}
