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
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _termsAccepted = false;
  bool _newsletter = true;
  String _goal = 'buy';
  final Set<String> _interests = {'apartments'};
  double _budget = 250000;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  double _passwordStrength() {
    final text = _passwordController.text;
    if (text.isEmpty) return 0;
    double score = 0;
    if (text.length >= 6) score += 0.3;
    if (text.length >= 10) score += 0.2;
    if (RegExp(r'[A-Z]').hasMatch(text)) score += 0.2;
    if (RegExp(r'[0-9]').hasMatch(text)) score += 0.2;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(text)) score += 0.1;
    return score.clamp(0, 1);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).t('accept_terms'))),
      );
      return;
    }
    final auth = NotifierProvider.read<AuthController>(context);
    await auth.register(
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
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) =>
                    value != null && value.length >= 6 ? null : strings.t('password_hint'),
              ).fadeMove(delay: 160),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _passwordStrength(),
                minHeight: 6,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ).fadeMove(delay: 170),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: strings.t('confirm_password_hint'),
                  prefixIcon: const FaIcon(FontAwesomeIcons.lock, size: 16),
                  suffixIcon: IconButton(
                    icon: FaIcon(
                      _obscureConfirm
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 16,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (value) => value == _passwordController.text
                    ? null
                    : strings.t('confirm_password_hint'),
              ).fadeMove(delay: 200),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  strings.t('goal_title'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ).fadeMove(delay: 220),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'buy', label: Text(strings.t('goal_buy'))),
                  ButtonSegment(value: 'rent', label: Text(strings.t('goal_rent'))),
                  ButtonSegment(value: 'invest', label: Text(strings.t('goal_invest'))),
                ],
                selected: {_goal},
                onSelectionChanged: (values) {
                  setState(() => _goal = values.first);
                },
              ).fadeMove(delay: 240),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  strings.t('interest_title'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ).fadeMove(delay: 260),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in ['apartments', 'villas', 'cabins', 'commercial'])
                    FilterChip(
                      label: Text(strings.t(item)),
                      selected: _interests.contains(item),
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _interests.add(item);
                          } else {
                            _interests.remove(item);
                          }
                        });
                      },
                    ),
                ],
              ).fadeMove(delay: 280),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  strings.t('budget_title'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Slider(
                value: _budget,
                min: 50000,
                max: 1000000,
                divisions: 19,
                label: '${_budget.toStringAsFixed(0)} USD',
                onChanged: (value) => setState(() => _budget = value),
              ).fadeMove(delay: 300),
              SwitchListTile.adaptive(
                value: _newsletter,
                title: Text(strings.t('newsletter_opt_in')),
                onChanged: (value) => setState(() => _newsletter = value),
              ).fadeMove(delay: 320),
              CheckboxListTile(
                value: _termsAccepted,
                onChanged: (value) => setState(() => _termsAccepted = value ?? false),
                title: Text(strings.t('accept_terms')),
              ).fadeMove(delay: 340),
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
