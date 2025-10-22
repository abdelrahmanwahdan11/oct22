import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

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
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.bottomBar),
            boxShadow: AppShadows.soft,
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
                  ),
              ],
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
  });

  final _BottomItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected ? AppColors.blueDark : AppColors.textSecondary;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.chip),
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.base,
          curve: AppMotion.curve,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.blueSoft : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.chip),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(data.icon, color: color),
              const SizedBox(height: 4),
              Text(
                data.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<_BottomItemData> buildBottomItems(TextTheme textTheme) {
  return const [
    _BottomItemData(id: 'home', label: 'HOME', icon: Icons.home),
    _BottomItemData(id: 'device', label: 'DEVICE', icon: Icons.grid_view),
    _BottomItemData(id: 'room', label: 'ROOM', icon: Icons.door_sliding),
    _BottomItemData(id: 'more', label: 'MORE', icon: Icons.person),
  ];
}
