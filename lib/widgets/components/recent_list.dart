import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../animations/animated_reveal.dart';

class RecentList extends StatelessWidget {
  const RecentList({super.key, required this.title, required this.items, this.onTap});

  final String title;
  final List<String> items;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    final textTheme = Theme.of(context).textTheme;
    if (items.isEmpty) return const SizedBox.shrink();
    return AnimatedReveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(title, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final value = items[index];
              return GestureDetector(
                onTap: () => onTap?.call(value),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: colors.surfaceSoft,
                      child: Text(
                        value.substring(0, 2).toUpperCase(),
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 72,
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: textTheme.caption?.copyWith(color: colors.textSecondary),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
