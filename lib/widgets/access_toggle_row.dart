import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

class AccessToggleRow extends StatelessWidget {
  const AccessToggleRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onChanged,
    this.index = 0,
  });

  final String title;
  final String subtitle;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedReveal(
      delayFactor: index,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.curve,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            Switch(
              value: enabled,
              onChanged: onChanged,
              activeColor: AppColors.blueDark,
            ),
          ],
        ),
      ),
    );
  }
}
