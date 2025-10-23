import 'package:flutter/material.dart';

import '../core/design_system.dart';
import '../l10n/app_localizations.dart';

class FloatingDotMenu extends StatelessWidget {
  const FloatingDotMenu({
    super.key,
    required this.onAction,
  });

  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final actions = {
      'weight': strings.t('sort_weight'),
      'pallets': strings.t('sort_pallets'),
      'auto': strings.t('auto_assign'),
    };
    return Align(
      alignment: Alignment.center,
      child: PopupMenuButton<String>(
        tooltip: strings.t('optimizer'),
        offset: const Offset(0, -12),
        onSelected: onAction,
        itemBuilder: (context) => actions.entries
            .map(
              (entry) => PopupMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
        child: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: AppColors.lime,
            shape: BoxShape.circle,
            boxShadow: [AppShadows.card],
          ),
          child: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
