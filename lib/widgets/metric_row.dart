import 'package:flutter/material.dart';

import '../core/design_system.dart';

class MetricRow extends StatelessWidget {
  const MetricRow({
    super.key,
    required this.metrics,
  });

  final List<MetricValue> metrics;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: AppMotion.base,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
        boxShadow: [AppShadows.soft],
      ),
      child: Row(
        children: [
          for (var i = 0; i < metrics.length; i++)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metrics[i].label,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    metrics[i].value,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class MetricValue {
  const MetricValue({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
