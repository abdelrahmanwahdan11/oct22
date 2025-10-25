import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

class TransferReceiveScreen extends StatelessWidget {
  const TransferReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('receive'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
              ),
              alignment: Alignment.center,
              child: const Text('QR'),
            ),
            const SizedBox(height: 24),
            Text('0xABCD...1234', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(strings.t('copied'))));
              },
              child: const Text('Copy Address'),
            ),
          ],
        ),
      ),
    );
  }
}
