import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/orders_controller.dart';
import '../../data/models/order.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/components/order_keypad_sheet.dart';

class OrderSheet extends StatefulWidget {
  const OrderSheet({super.key, required this.assetId, required this.initialSide});

  final String assetId;
  final String initialSide;

  @override
  State<OrderSheet> createState() => _OrderSheetState();
}

class _OrderSheetState extends State<OrderSheet> {
  late String _side;
  String _type = 'Market';
  String _amount = '0';
  final _limitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _side = widget.initialSide;
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = NotifierProvider.of<OrdersController>(context);
    final strings = AppLocalizations.of(context);
    final colors = TradeXTheme.colorsOf(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.border,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ToggleButtons(
                  isSelected: ['buy', 'sell'].map((e) => _side == e).toList(),
                  onPressed: (index) {
                    setState(() => _side = index == 0 ? 'buy' : 'sell');
                  },
                  borderRadius: BorderRadius.circular(16),
                  selectedColor: Colors.white,
                  fillColor: _side == 'buy' ? colors.profit : colors.loss,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(strings.t('buy').toUpperCase()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(strings.t('sell').toUpperCase()),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ToggleButtons(
                  isSelected: ['Market', 'Limit'].map((e) => _type == e).toList(),
                  onPressed: (index) {
                    setState(() => _type = index == 0 ? 'Market' : 'Limit');
                  },
                  borderRadius: BorderRadius.circular(16),
                  selectedColor: Colors.white,
                  fillColor: colors.accent,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Market'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Limit'),
                    ),
                  ],
                ),
                if (_type == 'Limit') ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _limitController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Limit Price'),
                  ),
                ],
                const SizedBox(height: 16),
                OrderKeypadSheet(
                  title: strings.t('amount_qty'),
                  onChanged: (value) => _amount = value,
                  onSubmit: () async {
                    final qty = double.tryParse(_amount) ?? 0;
                    if (qty <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter amount')),
                      );
                      return;
                    }
                    await orders.createOrder(
                      assetId: widget.assetId,
                      side: _side == 'buy' ? OrderSide.buy : OrderSide.sell,
                      type: _type == 'Market' ? OrderType.market : OrderType.limit,
                      qty: qty,
                      limitPrice: _type == 'Limit' ? double.tryParse(_limitController.text) : null,
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.t('mock_order'))),
                    );
                    Navigator.of(context).pop();
                  },
                  ctaLabel: strings.t('continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
