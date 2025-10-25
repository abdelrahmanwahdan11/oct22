import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/feature_catalog.dart';

class FeatureShowcase extends StatelessWidget {
  const FeatureShowcase({super.key, this.limit});

  final int? limit;

  @override
  Widget build(BuildContext context) {
    final features = limit == null
        ? kProTradingFeatures
        : kProTradingFeatures.take(limit!).toList();
    final theme = Theme.of(context);
    final background = theme.colorScheme.surface;
    final borderColor = theme.colorScheme.outline.withOpacity(0.12);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final feature in features)
          _FeatureCard(
            descriptor: feature,
            background: background,
            borderColor: borderColor,
            textTheme: theme.textTheme,
          ).animate(interval: 60.ms).fadeIn().moveY(begin: 12, end: 0),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.descriptor,
    required this.background,
    required this.borderColor,
    required this.textTheme,
  });

  final FeatureDescriptor descriptor;
  final Color background;
  final Color borderColor;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(descriptor.icon, size: 20),
          const SizedBox(height: 12),
          Text(
            descriptor.title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            descriptor.subtitle,
            style: textTheme.bodySmall?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}
