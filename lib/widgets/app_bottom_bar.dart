import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

typedef BottomNavCallback = void Function(int index);

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.items,
  });

  final int currentIndex;
  final BottomNavCallback onChanged;
  final List<_BottomItemData> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: AnimatedReveal(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadii.bottomBar),
              boxShadow: isDark ? null : AppShadows.soft,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var i = 0; i < items.length; i++)
                    _BottomItem(
                      data: items[i],
                      selected: i == currentIndex,
                      onTap: () => onChanged(i),
                      index: i,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomItemData {
  const _BottomItemData({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.data,
    required this.selected,
    required this.onTap,
    required this.index,
  });

  final _BottomItemData data;
  final bool selected;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final capsuleColor = selected
        ? (scheme.brightness == Brightness.dark
            ? scheme.primary.withOpacity(0.18)
            : scheme.primary.withOpacity(0.12))
        : Colors.transparent;
    final iconColor = selected ? scheme.primary : scheme.onSurface.withOpacity(0.6);
    final textColor = selected ? scheme.onSurface : scheme.onSurface.withOpacity(0.6);
    return Expanded(
      child: AnimatedReveal(
        delayFactor: index,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.chip),
          onTap: onTap,
          child: AnimatedContainer(
            duration: AppMotion.base,
            curve: AppMotion.curve,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: capsuleColor,
              borderRadius: BorderRadius.circular(AppRadii.chip),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(data.icon, color: iconColor),
                const SizedBox(height: 4),
                Text(
                  data.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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

List<_BottomItemData> buildBottomItems({
  required String home,
  required String devices,
  required String rooms,
  required String more,
}) {
  return [
    _BottomItemData(id: 'home', label: home, icon: Icons.home),
    _BottomItemData(id: 'device', label: devices, icon: Icons.grid_view),
    _BottomItemData(id: 'room', label: rooms, icon: Icons.door_sliding),
    _BottomItemData(id: 'more', label: more, icon: Icons.person),
  ];
}
