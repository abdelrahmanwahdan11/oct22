import 'package:flutter/material.dart';

import '../core/design_system.dart';

class TopTabs extends StatelessWidget {
  const TopTabs({
    super.key,
    required this.items,
    required this.selected,
  });

  final List<String> items;
  final String selected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
        boxShadow: [AppShadows.soft],
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: AnimatedContainer(
                duration: AppMotion.base,
                curve: AppMotion.curve,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: item == selected
                      ? AppColors.limeSoft
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.radiusMD.x),
                ),
                child: Center(
                  child: Text(
                    item,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: item == selected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
