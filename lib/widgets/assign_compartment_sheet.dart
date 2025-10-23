import 'package:flutter/material.dart';

import '../core/design_system.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';

const String removeAssignmentValue = '__remove_assignment__';

Future<String?> showAssignCompartmentSheet({
  required BuildContext context,
  required List<Compartment> compartments,
  required Stop stop,
}) {
  final strings = AppLocalizations.of(context);
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: AppRadii.sheet,
          boxShadow: [AppShadows.card],
        ),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.t('assign_stop'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              strings.t('select_compartment'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final compartment = compartments[index];
                  final remaining = compartment.capacityLb - compartment.currentLb;
                  final progress = compartment.capacityLb == 0
                      ? 0.0
                      : compartment.currentLb / compartment.capacityLb;
                  return ListTile(
                    onTap: () => Navigator.of(sheetContext).pop(compartment.id),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.lime.withOpacity(0.3),
                      child: Text(compartment.label, style: const TextStyle(color: AppColors.textPrimary)),
                    ),
                    title: Text('${compartment.label} • ${compartment.currentLb}/${compartment.capacityLb} ${strings.t('lb')}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          color: AppColors.limeDark,
                          backgroundColor: AppColors.border,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${strings.t('remaining_capacity')}: $remaining ${strings.t('lb')}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: compartments.length,
              ),
            ),
            if (stop.lockedToCompartmentId != null) ...[
              const Divider(height: 24),
              ListTile(
                onTap: () => Navigator.of(sheetContext).pop(removeAssignmentValue),
                leading: const Icon(Icons.close, color: AppColors.danger),
                title: Text(strings.t('remove_assignment')),
              ),
            ],
          ],
        ),
      );
    },
  );
}
