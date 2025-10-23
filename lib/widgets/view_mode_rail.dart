import 'package:flutter/material.dart';

import '../core/design_system.dart';

class ViewModeRail extends StatelessWidget {
  const ViewModeRail({
    super.key,
    required this.icons,
    this.selectedIndex = 0,
  });

  final List<String> icons;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        duration: AppMotion.base,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [AppShadows.soft],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < icons.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: i == selectedIndex ? AppColors.limeSoft : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadii.radiusMD.x),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/${icons[i]}.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
