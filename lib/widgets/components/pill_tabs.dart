import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/animations.dart';

class PillTabs extends StatefulWidget {
  const PillTabs({super.key, this.onChanged});

  final ValueChanged<int>? onChanged;

  @override
  State<PillTabs> createState() => _PillTabsState();
}

class _PillTabsState extends State<PillTabs> {
  int _index = 0;

  static const _tabs = ['summary', 'market', 'news'];

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF14171C) : const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = i == _index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _index = i;
                });
                widget.onChanged?.call(i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected
                      ? (isDark ? Colors.white : Colors.black)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  strings.t(_tabs[i]),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: selected
                            ? (isDark ? Colors.black : Colors.white)
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          );
        }),
      ),
    ).fadeMove();
  }
}
