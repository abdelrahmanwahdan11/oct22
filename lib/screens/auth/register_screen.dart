import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/controller_scope.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _autoValidate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final auth = context.watchController<AuthController>();
    final settings = context.watchController<SettingsController>();
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('register'))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode:
                _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: strings.t('full_name')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return strings.t('required_field');
                    }
                    if (value.length < 2) {
                      return 'Too short';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return strings.t('required_field');
                    }
                    if (value.length < 8) {
                      return 'Min 8 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: strings.t('password')),
                  obscureText: true,
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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmController,
                  decoration: InputDecoration(labelText: strings.t('confirm_password')),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return strings.t('password_mismatch');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () async {
                    final valid = _formKey.currentState?.validate() ?? false;
                    if (!valid) {
                      setState(() => _autoValidate = true);
                      return;
                    }
                    await auth.register(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );
                    await settings.completeOnboarding();
                    if (!mounted) return;
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('portfolio.home', (route) => false);
                  },
                  child: Text(strings.t('register')),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('auth.login'),
                  child: Text(strings.t('login')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
