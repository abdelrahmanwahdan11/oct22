import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/animations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final auth = NotifierProvider.read<AuthController>(context);
      auth.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushReplacementNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    return Scaffold(
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: settings.isDarkMode),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    strings.t('login_title'),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ).fadeMove(),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: strings.t('email_hint'),
                      prefixIcon: const FaIcon(FontAwesomeIcons.solidEnvelope, size: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return strings.t('email_hint');
                      }
                      if (!value.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ).fadeMove(delay: 80),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: strings.t('password_hint'),
                      prefixIcon: const FaIcon(FontAwesomeIcons.lock, size: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Min 6 chars';
                      }
                      return null;
                    },
                  ).fadeMove(delay: 120),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _submit,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.arrowRightToBracket, size: 16),
                        const SizedBox(width: 12),
                        Text(strings.t('login')),
                      ],
                    ),
                  ).fadeMove(delay: 160),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      final auth = NotifierProvider.read<AuthController>(context);
                      auth.continueAsGuest();
                      Navigator.of(context).pushReplacementNamed('home');
                    },
                    child: Text(strings.t('guest')),
                  ).fadeMove(delay: 200),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed('auth.register'),
                        child: Text(strings.t('create_account')),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed('auth.forgot'),
                        child: Text(strings.t('forgot_password')),
                      ),
                    ],
                  ).fadeMove(delay: 240),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
