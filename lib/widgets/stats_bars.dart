import 'package:flutter/material.dart';

import '../core/design_system.dart';

class StatsBars extends StatelessWidget {
  const StatsBars({
    super.key,
    required this.data,
  });

  final List<StatsBarData> data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final maxValue = data.fold<double>(0, (value, item) => value > item.value ? value : item.value);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
        boxShadow: [AppShadows.soft],
      ),
      child: Column(
        children: data
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.label,
                          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          item.valueLabel,
                          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final ratio = maxValue == 0 ? 0 : item.value / maxValue;
                        return Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              duration: AppMotion.base,
                              curve: AppMotion.curve,
                              width: constraints.maxWidth * ratio,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.lime, AppColors.limeDark],
                                ),
                                borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class StatsBarData {
  const StatsBarData({
    required this.label,
    required this.value,
    required this.valueLabel,
  });

  final String label;
  final double value;
  final String valueLabel;
}
