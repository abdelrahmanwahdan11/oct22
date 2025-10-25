import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/fx_commodity.dart';

class CommodityTile extends StatelessWidget {
  const CommodityTile({
    super.key,
    required this.commodity,
    this.onToggleWatch,
    this.isWatched = false,
  });

  final Commodity commodity;
  final VoidCallback? onToggleWatch;
  final bool isWatched;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    final textTheme = Theme.of(context).textTheme;
    final changeColor = commodity.isGain ? colors.profit : colors.loss;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colors.surfaceSoft,
            child: FaIcon(FontAwesomeIcons.coins, size: 16, color: colors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commodity.name, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('per ${commodity.unit}', style: textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatCurrency(commodity.price), style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(formatChangePct(commodity.changePct), style: textTheme.bodySmall?.copyWith(color: changeColor)),
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
    ).animate(interval: 60.ms).fadeIn().scale(begin: 0.98, end: 1);
  }
}
