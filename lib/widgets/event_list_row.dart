import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

class EventListRow extends StatelessWidget {
  const EventListRow({
    super.key,
    required this.title,
    required this.time,
    required this.duration,
    this.badge,
    this.index = 0,
  });

  final String title;
  final String time;
  final String duration;
  final String? badge;
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
          color: Colors.white.withOpacity(0.82),
          borderRadius: BorderRadius.circular(AppRadii.md),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppMotion.fast,
              curve: AppMotion.curve,
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.blueSoft,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: const Icon(Icons.videocam_outlined, color: AppColors.blueDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('$time • $duration', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            if (badge != null)
              AnimatedContainer(
                duration: AppMotion.base,
                curve: AppMotion.curve,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.blueDark,
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                ),
                child: Text(
                  badge!,
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
