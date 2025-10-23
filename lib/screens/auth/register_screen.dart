import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../core/design_system.dart';
import '../../core/navigation.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/animated_entry.dart';
import '../../widgets/decorated_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return DecoratedScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedEntry(
                    child: Text(
                      strings.t('register_title'),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 120),
                    child: Text(
                      strings.t('register_subtitle'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 140),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: strings.t('name'),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return strings.t('invalid_name');
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 180),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: strings.t('email'),
                        prefixIcon: const Icon(Icons.alternate_email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        final emailRegex = RegExp(r'^([\w\-\.]+)@([\w\-]+)\.([A-Za-z]{2,})$');
                        if (value == null || value.isEmpty || !emailRegex.hasMatch(value.trim())) {
                          return strings.t('invalid_email');
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 220),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: strings.t('password'),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          tooltip: strings.t('toggle_password'),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return strings.t('weak_password');
                        }
                        if (value.length < 8 ||
                            !RegExp(r'[A-Z]').hasMatch(value) ||
                            !RegExp(r'[0-9]').hasMatch(value) ||
                            !RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return strings.t('weak_password');
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 260),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: strings.t('confirm_password'),
                        prefixIcon: const Icon(Icons.verified_user_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          tooltip: strings.t('toggle_password'),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return strings.t('password_mismatch');
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 320),
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: AppColors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: _submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(strings.t('create_account_action')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(strings.t('have_account')),
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(AppNavigation.routes['auth.login']!),
                          child: Text(strings.t('sign_in')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _submitting = true);
    final result = await widget.authController.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      name: _nameController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (result.success) {
      if (!widget.authController.completedOnboarding) {
        await widget.authController.completeOnboarding();
      }
      Navigator.of(context).pushReplacementNamed(AppNavigation.routes['planning']!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).t(result.message ?? 'invalid_email'))),
      );
    }
  }
}
