import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/plan_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/app_scope.dart';
import '../../data/models/plan_item.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.item,
  });

  final PlanItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final planController = AppScope.of(context).planController;
    final statusColor = _statusColor(context, item.status);
    final name = planController.supplementName(item.supplementId);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.86),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: statusColor.withOpacity(0.2),
            child: FaIcon(
              FontAwesomeIcons.capsules,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text('${item.time} • ${item.dose}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      _statusLabel(context, item.status),
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    _ActionChip(
                      label: l10n.translate('take_now'),
                      icon: FontAwesomeIcons.check,
                      onTap: () => planController.markStatus(
                        item.supplementId,
                        PlanStatus.taken,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ActionChip(
                      label: l10n.translate('skip'),
                      icon: FontAwesomeIcons.xmark,
                      onTap: () => planController.markStatus(
                        item.supplementId,
                        PlanStatus.skipped,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ActionChip(
                      label: l10n.translate('remind_me'),
                      icon: FontAwesomeIcons.bell,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0);
  }

  Color _statusColor(BuildContext context, PlanStatus status) {
    final theme = Theme.of(context);
    switch (status) {
      case PlanStatus.taken:
        return theme.colorScheme.primary;
      case PlanStatus.skipped:
        return theme.colorScheme.error;
      case PlanStatus.pending:
      default:
        return theme.colorScheme.secondary;
    }
  }

  String _statusLabel(BuildContext context, PlanStatus status) {
    final l10n = AppLocalizations.of(context);
    switch (status) {
      case PlanStatus.taken:
        return l10n.translate('mark_taken');
      case PlanStatus.skipped:
        return l10n.translate('mark_skipped');
      case PlanStatus.pending:
      default:
        return l10n.translate('mark_pending');
    }
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.72),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 14),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
