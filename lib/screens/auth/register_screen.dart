import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/auth_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/utils/animations.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = NotifierProvider.read<AuthController>(context);
    auth.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );
    Navigator.of(context).pushReplacementNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('create_account')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: strings.t('name_hint'),
                  prefixIcon: const FaIcon(FontAwesomeIcons.user, size: 16),
                ),
                validator: (value) =>
                    value != null && value.length >= 2 ? null : strings.t('name_hint'),
              ).fadeMove(),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: strings.t('email_hint'),
                  prefixIcon: const FaIcon(FontAwesomeIcons.solidEnvelope, size: 16),
                ),
                validator: (value) =>
                    value != null && value.contains('@') ? null : strings.t('email_hint'),
              ).fadeMove(delay: 80),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: strings.t('phone_hint'),
                  prefixIcon: const FaIcon(FontAwesomeIcons.phone, size: 16),
                ),
                validator: (value) =>
                    value != null && value.length >= 8 ? null : strings.t('phone_hint'),
              ).fadeMove(delay: 120),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: strings.t('password_hint'),
                  prefixIcon: const FaIcon(FontAwesomeIcons.lock, size: 16),
                ),
                validator: (value) =>
                    value != null && value.length >= 6 ? null : strings.t('password_hint'),
              ).fadeMove(delay: 160),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: strings.t('confirm_password_hint'),
                  prefixIcon: const FaIcon(FontAwesomeIcons.lock, size: 16),
                ),
                validator: (value) => value == _passwordController.text
                    ? null
                    : strings.t('confirm_password_hint'),
              ).fadeMove(delay: 200),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: Text(strings.t('register')),
              ).fadeMove(delay: 240),
            ],
          ),
        ),
      ),
    );
  }
}
