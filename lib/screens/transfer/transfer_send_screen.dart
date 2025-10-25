import 'package:flutter/material.dart';

import '../../controllers/portfolio_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../widgets/components/order_keypad_sheet.dart';
import '../../widgets/components/recent_list.dart';

class TransferSendScreen extends StatefulWidget {
  const TransferSendScreen({super.key});

  @override
  State<TransferSendScreen> createState() => _TransferSendScreenState();
}

class _TransferSendScreenState extends State<TransferSendScreen> {
  final _addressController = TextEditingController();
  String _amount = '0';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final portfolio = NotifierProvider.of<PortfolioController>(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('send'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address or Username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 24),
            RecentList(
              title: strings.t('recent'),
              items: portfolio.recentRecipients,
              onTap: (value) => _addressController.text = value,
            ),
            const SizedBox(height: 24),
            OrderKeypadSheet(
              title: strings.t('amount_usd'),
              onChanged: (value) => _amount = value,
              onSubmit: () async {
                final amount = double.tryParse(_amount) ?? 0;
                if (amount <= 0 || _addressController.text.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Enter address and amount')));
                  return;
                }
                await portfolio.addRecent(_addressController.text.trim());
                if (!mounted) return;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(strings.t('mock_send'))));
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
