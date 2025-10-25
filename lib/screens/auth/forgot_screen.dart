import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('forgot_password'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.t('email'), style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: strings.t('email')),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mock: reset link sent')),
                );
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
