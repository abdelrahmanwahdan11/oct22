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
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _initialized = false;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final auth = NotifierProvider.read<AuthController>(context);
      setState(() => _submitting = true);
      await auth.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() => _submitting = false);
      Navigator.of(context).pushReplacementNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    final auth = NotifierProvider.of<AuthController>(context);
    if (!_initialized) {
      _initialized = true;
      _rememberMe = auth.rememberMe;
      if (auth.rememberedEmail.isNotEmpty) {
        _emailController.text = auth.rememberedEmail;
      }
    }
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
                  const SizedBox(height: 12),
                  Text(
                    strings.t('login_subtitle'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                  ).fadeMove(delay: 40),
                  const SizedBox(height: 28),
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
                        return strings.t('email_invalid');
                      }
                      return null;
                    },
                  ).fadeMove(delay: 80),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: strings.t('password_hint'),
                      prefixIcon: const FaIcon(FontAwesomeIcons.lock, size: 16),
                      suffixIcon: IconButton(
                        icon: FaIcon(
                          _obscurePassword
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          size: 16,
                        ),
                        onPressed: () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return strings.t('password_length');
                      }
                      return null;
                    },
                  ).fadeMove(delay: 120),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _rememberMe,
                    title: Text(strings.t('remember_me')),
                    onChanged: (value) async {
                      final checked = value ?? false;
                      setState(() => _rememberMe = checked);
                      await auth.setRememberMe(checked);
                    },
                  ).fadeMove(delay: 140),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.arrowRightToBracket, size: 16),
                              const SizedBox(width: 12),
                              Text(strings.t('login')),
                            ],
                          ),
                  ).fadeMove(delay: 180),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      NotifierProvider.read<AuthController>(context).continueAsGuest();
                      Navigator.of(context).pushReplacementNamed('home');
                    },
                    icon: const FaIcon(FontAwesomeIcons.personWalkingArrowRight, size: 16),
                    label: Text(strings.t('guest')),
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
                  ).fadeMove(delay: 220),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strings.t('login_with_sms'))),
                          );
                        },
                        icon: const FaIcon(FontAwesomeIcons.message, size: 16),
                        label: Text(strings.t('sms_login')),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strings.t('login_with_whatsapp'))),
                          );
                        },
                        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 16),
                        label: const Text('WhatsApp'),
                      ),
                    ],
                  ).fadeMove(delay: 240),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(FontAwesomeIcons.circleInfo, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            strings.t('login_support'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ).fadeMove(delay: 260),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
