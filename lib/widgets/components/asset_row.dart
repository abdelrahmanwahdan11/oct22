import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/asset.dart';
import '../animations/animated_reveal.dart';

class AssetRow extends StatelessWidget {
  const AssetRow({
    super.key,
    required this.asset,
    required this.quote,
    this.onTap,
    this.onToggleWatch,
    this.isWatched = false,
  });

  final Asset asset;
  final Quote quote;
  final VoidCallback? onTap;
  final VoidCallback? onToggleWatch;
  final bool isWatched;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    final textTheme = Theme.of(context).textTheme;
    final changeColor = quote.changePct >= 0 ? colors.profit : colors.loss;
    return AnimatedReveal(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
            Hero(
              tag: 'asset_image_${asset.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: 48,
                  width: 48,
                  color: colors.surfaceSoft,
                  child: Image.network(
                    asset.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      FontAwesomeIcons.coins,
                      size: 20,
                      color: colors.muted,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.name, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    asset.symbol,
                    style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(
                    quote.price,
                    currency: asset.currency,
                  ),
                  style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      quote.changePct >= 0
                          ? FontAwesomeIcons.arrowTrendUp
                          : FontAwesomeIcons.arrowTrendDown,
                      size: 12,
                      color: changeColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatChangePct(quote.changePct),
                      style: textTheme.bodySmall?.copyWith(color: changeColor),
                    ),
                  ],
                ),
              ],
            ),
            if (onToggleWatch != null) ...[
              const SizedBox(width: 12),
              IconButton(
                icon: FaIcon(
                  isWatched ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                  color: isWatched ? colors.accent : colors.muted,
                  size: 18,
                ),
                onPressed: onToggleWatch,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
