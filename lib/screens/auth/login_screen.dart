import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/controller_scope.dart';
import '../../widgets/animations/animated_reveal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _autoValidate = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final auth = context.watchController<AuthController>();
    final settings = context.watchController<SettingsController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.t('login'), style: Theme.of(context).textTheme.h1),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                autovalidateMode:
                    _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    AnimatedReveal(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: strings.t('email')),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return strings.t('required_field');
                          }
                          if (!value.contains('@')) {
                            return strings.t('invalid_email');
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedReveal(
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: strings.t('password'),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(() {
                              _obscurePassword = !_obscurePassword;
                            }),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return strings.t('required_field');
                          }
                          if (value.length < 6) {
                            return 'Min 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              final valid = _formKey.currentState?.validate() ?? false;
                              if (!valid) {
                                setState(() => _autoValidate = true);
                                return;
                              }
                              await auth.login(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                              await settings.completeOnboarding();
                              if (!mounted) return;
                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil('portfolio.home', (route) => false);
                            },
                      child: auth.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(strings.t('login')),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () async {
                        await auth.continueAsGuest();
                        await settings.completeOnboarding();
                        if (!mounted) return;
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('portfolio.home', (route) => false);
                      },
                      child: Text(strings.t('continue_guest')),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('auth.register'),
                      child: Text(strings.t('register')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('auth.forgot'),
                      child: Text(strings.t('forgot_password')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
