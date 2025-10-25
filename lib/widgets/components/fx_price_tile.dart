import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/fx_commodity.dart';
import '../animations/animated_reveal.dart';

class FxPriceTile extends StatelessWidget {
  const FxPriceTile({
    super.key,
    required this.pair,
    this.onToggleWatch,
    this.isWatched = false,
  });

  final FxPair pair;
  final VoidCallback? onToggleWatch;
  final bool isWatched;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    final textTheme = Theme.of(context).textTheme;
    final changeColor = pair.isGain ? colors.profit : colors.loss;
    return AnimatedReveal(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
            radius: 24,
            backgroundColor: colors.surfaceSoft,
            child: Text('${pair.base}\n${pair.quote}',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${pair.base}/${pair.quote}',
                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(pair.timestamp.toLocal().toIso8601String().substring(11, 16),
                    style: textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(pair.price.toStringAsFixed(5),
                  style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(formatChangePct(pair.changePct), style: textTheme.bodySmall?.copyWith(color: changeColor)),
            ],
          ),
          if (onToggleWatch != null) ...[
            const SizedBox(width: 12),
            IconButton(
              onPressed: onToggleWatch,
              icon: FaIcon(
                isWatched ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                color: isWatched ? colors.accent : colors.muted,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
