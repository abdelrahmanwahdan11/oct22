import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';

class BottomCapsuleBar extends StatelessWidget {
  const BottomCapsuleBar({
    super.key,
    required this.onBuy,
    required this.onSell,
    required this.onExchange,
    required this.buyLabel,
    required this.sellLabel,
    required this.exchangeLabel,
  });

  final VoidCallback onBuy;
  final VoidCallback onSell;
  final VoidCallback onExchange;
  final String buyLabel;
  final String sellLabel;
  final String exchangeLabel;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          _CapsuleButton(
            icon: FontAwesomeIcons.arrowUp,
            label: buyLabel,
            onTap: onBuy,
            background: colors.accent,
            foreground: colors.bg,
          ),
          const SizedBox(width: 12),
          _CapsuleButton(
            icon: FontAwesomeIcons.arrowDown,
            label: sellLabel,
            onTap: onSell,
            background: colors.surfaceSoft,
            foreground: colors.textPrimary,
          ),
          const SizedBox(width: 12),
          _CapsuleButton(
            icon: FontAwesomeIcons.rightLeft,
            label: exchangeLabel,
            onTap: onExchange,
            background: colors.surfaceSoft,
            foreground: colors.textPrimary,
          ),
        ],
      ),
    ).animate().fadeIn(280.ms).moveY(begin: 16, end: 0, curve: Curves.easeOut);
  }
}

class _CapsuleButton extends StatelessWidget {
  const _CapsuleButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, size: 16),
              const SizedBox(width: 8),
              Text(label, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
