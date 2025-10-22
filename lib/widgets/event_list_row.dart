import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class EventListRow extends StatelessWidget {
  const EventListRow({
    super.key,
    required this.title,
    required this.time,
    required this.duration,
    this.badge,
  });

  final String title;
  final String time;
  final String duration;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(AppRadii.md),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
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
            Container(
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
    );
  }
}
