import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({
    super.key,
    required this.device,
    required this.onTap,
    required this.onToggle,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.statusLabel,
    this.energyKwh,
    this.batteryLevel,
    this.index = 0,
  });

  final Device device;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final String? statusLabel;
  final double? energyKwh;
  final int? batteryLevel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final status = statusLabel ?? (device.isOn ? 'ON' : 'OFF');
    final theme = Theme.of(context);
    return AnimatedReveal(
      delayFactor: index,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.base,
          curve: AppMotion.curve,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            boxShadow: AppShadows.soft,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: AppMotion.base,
                    curve: AppMotion.curve,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          device.isOn ? AppColors.success.withOpacity(0.12) : AppColors.border,
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                    ),
                    child: Text(
                      status,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: device.isOn ? AppColors.success : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (onFavoriteToggle != null)
                    AnimatedScale(
                      scale: isFavorite ? 1.05 : 1,
                      duration: AppMotion.fast,
                      curve: AppMotion.curve,
                      child: IconButton(
                        onPressed: onFavoriteToggle,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? AppColors.warning : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  Switch(
                    value: device.isOn,
                    onChanged: onToggle,
                    activeColor: AppColors.blueDark,
                  ),
                ],
              ),
              if (energyKwh != null || batteryLevel != null) ...[
                const SizedBox(height: 8),
                AnimatedOpacity(
                  duration: AppMotion.base,
                  opacity: 1,
                  child: Row(
                    children: [
                      if (energyKwh != null) ...[
                        Icon(Icons.bolt, size: 16, color: AppColors.blueDark),
                        const SizedBox(width: 6),
                        Text(
                          '${energyKwh!.toStringAsFixed(0)} kWh',
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                      if (energyKwh != null && batteryLevel != null)
                        const SizedBox(width: 12),
                      if (batteryLevel != null) ...[
                        Icon(Icons.battery_charging_full, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          '$batteryLevel%',
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        device.name,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Hero(
                      tag: 'device_image_${device.id}',
                      child: AnimatedScale(
                        scale: device.isOn ? 1 : 0.95,
                        duration: AppMotion.base,
                        curve: AppMotion.curve,
                        child: Image.asset(
                          device.image,
                          width: 72,
                          height: 72,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
