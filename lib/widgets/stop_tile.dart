import 'package:flutter/material.dart';

import '../core/design_system.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';

class StopTile extends StatelessWidget {
  const StopTile({
    super.key,
    required this.stop,
    this.onToggleSelect,
    this.onActionSelected,
    this.onAssign,
    this.dragHandle,
  });

  final Stop stop;
  final VoidCallback? onToggleSelect;
  final ValueChanged<String>? onActionSelected;
  final VoidCallback? onAssign;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);
    return AnimatedScale(
      scale: stop.selected ? 1.02 : 1,
      duration: AppMotion.base,
      child: AnimatedContainer(
        duration: AppMotion.base,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
          boxShadow: [AppShadows.soft],
          border: Border.all(
            color: stop.selected
                ? AppColors.limeDark.withOpacity(0.4)
                : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onAssign,
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.add, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        stop.code,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (stop.selected)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.limeSoft,
                            borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
                          ),
                          child: Text(
                            strings.t('selected'),
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stop.address,
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _Badge(label: '${stop.pallets} ${strings.t('pallets')}'),
                      _Badge(label: '${stop.weightLb} ${strings.t('lb')}'),
                      _Badge(label: '${strings.t('eta_label')} ${stop.eta}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                _DotMenu(onSelected: onActionSelected),
                if (dragHandle != null) ...[
                  const SizedBox(height: 16),
                  dragHandle!,
                ],
                if (onToggleSelect != null) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: onToggleSelect,
                    child: Icon(
                      stop.selected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: stop.selected ? AppColors.blue : AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.limeSoft,
        borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
      ),
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DotMenu extends StatelessWidget {
  const _DotMenu({this.onSelected});

  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PopupMenuButton<String>(
      tooltip: strings.t('more_actions'),
      offset: const Offset(0, 32),
      onSelected: onSelected,
      itemBuilder: (context) => [
        PopupMenuItem(value: 'assign', child: Text(strings.t('assign_compartment'))),
        PopupMenuItem(value: 'reorder', child: Text(strings.t('reorder'))),
        PopupMenuItem(value: 'delete', child: Text(strings.t('delete'))),
      ],
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [AppShadows.soft],
        ),
        child: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
      ),
    );
  }
}
