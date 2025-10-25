import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../animations/animated_reveal.dart';

class OrderKeypadSheet extends StatefulWidget {
  const OrderKeypadSheet({
    super.key,
    required this.title,
    required this.onChanged,
    required this.onSubmit,
    this.initialValue = '0',
    this.ctaLabel,
  });

  final String title;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final String initialValue;
  final String? ctaLabel;

  @override
  State<OrderKeypadSheet> createState() => _OrderKeypadSheetState();
}

class _OrderKeypadSheetState extends State<OrderKeypadSheet> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _input(String key) {
    setState(() {
      if (key == '←') {
        if (_value.length <= 1) {
          _value = '0';
        } else {
          _value = _value.substring(0, _value.length - 1);
        }
      } else if (key == '.') {
        if (!_value.contains('.')) {
          _value += '.';
        }
      } else {
        if (_value == '0') {
          _value = key;
        } else {
          _value += key;
        }
      }
      widget.onChanged(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    final textTheme = Theme.of(context).textTheme;
    const buttons = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '←'];
    return AnimatedReveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Text(widget.title, style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 12),
        Text(
          _value,
          textAlign: TextAlign.right,
          style: textTheme.display,
        ),
        const SizedBox(height: 20),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            final label = buttons[index];
            final isBackspace = label == '←';
            return ElevatedButton(
              onPressed: () => _input(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.surface,
                foregroundColor: colors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text(
                isBackspace ? '⌫' : label,
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: widget.onSubmit,
          child: Text(widget.ctaLabel ?? 'Continue'),
        ),
      ],
    );
  }
}
