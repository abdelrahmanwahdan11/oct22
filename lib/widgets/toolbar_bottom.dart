import 'package:flutter/material.dart';

import '../core/design_system.dart';
import '../core/navigation.dart';

class ToolbarBottom extends StatelessWidget {
  const ToolbarBottom({
    super.key,
    required this.items,
    required this.activeId,
    required this.onSelected,
  });

  final List<ToolbarItem> items;
  final String activeId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusBottomBar.x),
        boxShadow: [AppShadows.card],
      ),
      child: Row(
        children: items
            .map(
              (item) => Expanded(
                child: GestureDetector(
                  onTap: () => onSelected(item.id),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: item.id == 'optimizer'
                          ? AppColors.lime
                          : item.id == activeId
                              ? AppColors.limeSoft
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.id == 'optimizer'
                          ? AppColors.textPrimary
                          : item.id == activeId
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
