import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class RoomMiniPanel extends StatelessWidget {
  const RoomMiniPanel({
    super.key,
    required this.title,
    required this.devicesSummary,
    required this.temperature,
  });

  final String title;
  final String devicesSummary;
  final String temperature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: AppShadows.soft,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    devicesSummary,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Devices Active', style: theme.textTheme.bodyMedium),
                ],
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.blueSoft,
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    temperature,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.blueDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              _QuickToggle(icon: Icons.power_settings_new, label: 'ON'),
              SizedBox(width: 12),
              _QuickToggle(icon: Icons.lock_outline, label: 'Lock'),
              SizedBox(width: 12),
              _QuickToggle(icon: Icons.calendar_today_outlined, label: 'Plan'),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickToggle extends StatelessWidget {
  const _QuickToggle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.blueDark),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
