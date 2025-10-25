import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/news_item.dart';
import '../animations/animated_reveal.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.item, this.onTap});

  final NewsItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    final textTheme = Theme.of(context).textTheme;
    return AnimatedReveal(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
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
                FaIcon(FontAwesomeIcons.newspaper, size: 16, color: colors.accent),
                const SizedBox(width: 8),
                Text(item.source, style: textTheme.caption?.copyWith(color: colors.textSecondary)),
                const Spacer(),
                Text(item.time, style: textTheme.caption?.copyWith(color: colors.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),
            Text(item.title, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(item.summary, style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
