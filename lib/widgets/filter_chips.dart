import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

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
    return AnimatedReveal(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var index = 0; index < items.length; index++)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: AnimatedReveal(
                  delayFactor: index,
                  child: ChoiceChip(
                    label: Text(items[index]),
                    selected: selected == items[index],
                    onSelected: (_) => onSelected(items[index]),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.blueSoft,
                    labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selected == items[index]
                              ? AppColors.blueDark
                              : AppColors.textPrimary,
                          fontWeight:
                              selected == items[index] ? FontWeight.w600 : FontWeight.w500,
                        ),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
