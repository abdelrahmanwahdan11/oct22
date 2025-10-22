import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/auth_controller.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/screens/auth/login_screen.dart';
import 'package:smart_home_control/screens/auth/register_screen.dart';
import 'package:smart_home_control/screens/home/home_shell.dart';
import 'package:smart_home_control/screens/onboarding/onboarding_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final auth = scope.auth;
    final listenable = Listenable.merge([auth, scope.settings]);
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        switch (auth.step) {
          case AuthStep.loading:
            return const _SplashScreen();
          case AuthStep.onboarding:
            return const OnboardingScreen();
          case AuthStep.unauthenticated:
            return auth.screen == AuthScreen.signIn
                ? LoginScreen()
                : RegisterScreen();
          case AuthStep.authenticated:
            return const HomeShell();
        }
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
