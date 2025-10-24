import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/animations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('forgot_password')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: strings.t('email_hint'),
                  prefixIcon: const FaIcon(FontAwesomeIcons.solidEnvelope, size: 16),
                ),
                validator: (value) =>
                    value != null && value.contains('@') ? null : strings.t('email_hint'),
              ).fadeMove(),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: strings.t('phone_hint_optional'),
                  prefixIcon: const FaIcon(FontAwesomeIcons.phone, size: 16),
                ),
              ).fadeMove(delay: 60),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.t('saved_locally'))),
                    );
                  }
                },
                child: Text(strings.t('reset')),
              ).fadeMove(delay: 120),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.t('reset_via_sms'))),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.message, size: 16),
                    label: Text(strings.t('sms_login')),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.t('reset_via_whatsapp'))),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 16),
                    label: const Text('WhatsApp'),
                  ),
                ],
              ).fadeMove(delay: 180),
              const SizedBox(height: 16),
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
                    const FaIcon(FontAwesomeIcons.circleQuestion, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        strings.t('reset_support'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ).fadeMove(delay: 220),
            ],
          ),
        ),
      ),
    );
  }
}
