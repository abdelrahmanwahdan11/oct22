import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class ModePills extends StatelessWidget {
  const ModePills({
    super.key,
    required this.modes,
    required this.active,
    required this.onSelected,
  });

  final List<String> modes;
  final String active;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        for (final mode in modes)
          ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_iconFor(mode), size: 16,
                    color: active == mode ? Colors.white : AppColors.blueDark),
                const SizedBox(width: 6),
                Text(mode),
              ],
            ),
            selected: active == mode,
            onSelected: (_) => onSelected(mode),
            selectedColor: AppColors.blueDark,
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.border),
            ),
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: active == mode ? Colors.white : AppColors.textPrimary,
                  fontWeight: active == mode ? FontWeight.w600 : FontWeight.w500,
                ),
          ),
      ],
    );
  }

  IconData _iconFor(String mode) {
    switch (mode.toLowerCase()) {
      case 'cooling':
        return Icons.ac_unit;
      case 'dry':
        return Icons.water_drop_outlined;
      case 'heating':
        return Icons.local_fire_department_outlined;
      case 'fan':
        return Icons.air;
      default:
        return Icons.tune;
    }
  }
}
