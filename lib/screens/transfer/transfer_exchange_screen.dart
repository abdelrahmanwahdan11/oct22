import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../controllers/portfolio_controller.dart';
import '../../widgets/components/order_keypad_sheet.dart';

class TransferExchangeScreen extends StatefulWidget {
  const TransferExchangeScreen({super.key});

  @override
  State<TransferExchangeScreen> createState() => _TransferExchangeScreenState();
}

class _TransferExchangeScreenState extends State<TransferExchangeScreen> {
  String _amount = '0';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final portfolio = NotifierProvider.of<PortfolioController>(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('exchange'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('BTC → ETH'),
                  Text('0.05'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OrderKeypadSheet(
              title: strings.t('amount_qty'),
              onChanged: (value) => _amount = value,
              onSubmit: () async {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(strings.t('mock_exchange'))));
                await portfolio.addRecent('Swap BTC/ETH');
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              ctaLabel: strings.t('continue'),
            ),
          ],
        ),
      ),
    );
  }
}
