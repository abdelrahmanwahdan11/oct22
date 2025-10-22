import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/models/device.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({
    super.key,
    required this.device,
    required this.onTap,
    required this.onToggle,
  });

  final Device device;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: device.isOn ? AppColors.success.withOpacity(0.12) : AppColors.border,
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                  ),
                  child: Text(
                    device.isOn ? 'ON' : 'OFF',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: device.isOn ? AppColors.success : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Spacer(),
                Switch(
                  value: device.isOn,
                  onChanged: onToggle,
                  activeColor: AppColors.blueDark,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      device.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Hero(
                    tag: 'device_image_${device.id}',
                    child: Image.asset(
                      device.image,
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
