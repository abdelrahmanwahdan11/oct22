import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/portfolio.dart';

class PositionRow extends StatelessWidget {
  const PositionRow({
    super.key,
    required this.position,
    this.onBuy,
    this.onSell,
  });

  final PortfolioView position;
  final VoidCallback? onBuy;
  final VoidCallback? onSell;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    final textTheme = Theme.of(context).textTheme;
    final pnlColor = position.isGain ? colors.profit : colors.loss;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colors.surfaceSoft,
                backgroundImage: NetworkImage(position.image),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.name, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('${position.symbol} · ${position.qty.toStringAsFixed(3)}',
                        style: textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(formatCurrency(position.marketValue, compact: true),
                      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(formatChangePct(position.pnlPct), style: textTheme.bodySmall?.copyWith(color: pnlColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: FontAwesomeIcons.circleUp,
                  label: 'Buy',
                  onTap: onBuy,
                  backgroundColor: colors.accentSoft,
                  foregroundColor: colors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: FontAwesomeIcons.circleDown,
                  label: 'Sell',
                  onTap: onSell,
                  backgroundColor: colors.surfaceSoft,
                  foregroundColor: colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(interval: 60.ms).fadeIn().scale(begin: 0.98, end: 1);
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 16),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
