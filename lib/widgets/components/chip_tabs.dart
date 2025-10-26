import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChipTabs extends StatelessWidget {
  const ChipTabs({
    super.key,
    required this.tabs,
    required this.selectedTabs,
    required this.onTap,
    this.labelBuilder,
  });

  final List<String> tabs;
  final List<String> selectedTabs;
  final ValueChanged<String> onTap;
  final String Function(String value)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tabs.map((tab) {
        final selected = selectedTabs.contains(tab);
        return GestureDetector(
          onTap: () => onTap(tab),
          child: AnimatedContainer(
            duration: 260.ms,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dividerColor.withOpacity(0.4)),
              color: selected
                  ? theme.colorScheme.primary.withOpacity(0.16)
                  : theme.colorScheme.surface.withOpacity(0.72),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.22),
                        blurRadius: 18,
                        offset: const Offset(0, 12),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              labelBuilder?.call(tab) ?? tab,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.textTheme.bodyLarge?.color,
              ),
            ),
          ).animate().fadeIn().scale(begin: 0.98, end: 1),
        );
      }).toList(),
    );
  }
}
