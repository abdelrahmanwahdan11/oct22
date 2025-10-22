import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(item),
                selected: selected == item,
                onSelected: (_) => onSelected(item),
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.blueSoft,
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected == item
                          ? AppColors.blueDark
                          : AppColors.textPrimary,
                      fontWeight: selected == item ? FontWeight.w600 : FontWeight.w500,
                    ),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
