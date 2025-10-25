import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';

class TimeframeChips extends StatefulWidget {
  const TimeframeChips({super.key, this.onSelected, this.items = const ['1D', '1W', '1M', '6M', '1Y', 'All']});

  final ValueChanged<String>? onSelected;
  final List<String> items;

  @override
  State<TimeframeChips> createState() => _TimeframeChipsState();
}

class _TimeframeChipsState extends State<TimeframeChips> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    final textTheme = Theme.of(context).textTheme;
    return Wrap(
      spacing: 8,
      children: widget.items
          .map(
            (item) => ChoiceChip(
              label: Text(item, style: textTheme.bodyMedium?.copyWith(
                color: _selected == item ? colors.bg : colors.textSecondary,
                fontWeight: _selected == item ? FontWeight.w600 : FontWeight.w500,
              )),
              selected: _selected == item,
              onSelected: (_) {
                setState(() {
                  _selected = item;
                });
                widget.onSelected?.call(item);
              },
              selectedColor: colors.accent,
              backgroundColor: colors.surfaceSoft,
              side: BorderSide(color: colors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          )
          .toList(),
    ).animate().fadeIn(280.ms).moveY(begin: 16, end: 0, curve: Curves.easeOut);
  }
}
