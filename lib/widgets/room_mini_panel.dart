import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

class RoomMiniPanel extends StatelessWidget {
  const RoomMiniPanel({
    super.key,
    required this.title,
    required this.devicesSummary,
    required this.temperature,
    this.onPower,
    this.onLock,
    this.onPlan,
    this.index = 0,
  });

  final String title;
  final String devicesSummary;
  final String temperature;
  final VoidCallback? onPower;
  final VoidCallback? onLock;
  final VoidCallback? onPlan;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedReveal(
      delayFactor: index,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.curve,
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
                AnimatedContainer(
                  duration: AppMotion.fast,
                  curve: AppMotion.curve,
                  decoration: BoxDecoration(
                    color: AppColors.blueSoft,
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    temperature,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.blueDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _QuickToggle(icon: Icons.power_settings_new, label: 'ON', onTap: onPower),
                const SizedBox(width: 12),
                _QuickToggle(icon: Icons.lock_outline, label: 'Lock', onTap: onLock),
                const SizedBox(width: 12),
                _QuickToggle(icon: Icons.calendar_today_outlined, label: 'Plan', onTap: onPlan),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickToggle extends StatefulWidget {
  const _QuickToggle({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  State<_QuickToggle> createState() => _QuickToggleState();
}

class _QuickToggleState extends State<_QuickToggle> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: AnimatedReveal(
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap?.call();
          },
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.curve,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: _pressed ? AppColors.blueSoft : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                AnimatedScale(
                  scale: _pressed ? 0.9 : 1,
                  duration: AppMotion.fast,
                  curve: AppMotion.curve,
                  child: Icon(widget.icon, size: 18, color: AppColors.blueDark),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
