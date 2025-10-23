import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../core/design_system.dart';
import '../core/formatters.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../widgets/animated_entry.dart';
import '../widgets/decorated_scaffold.dart';

class RouteHistoryScreen extends StatelessWidget {
  const RouteHistoryScreen({super.key, required this.routeController});

  final RouteController routeController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return DecoratedScaffold(
      appBar: AppBar(
        title: Text(strings.t('route_history')),
        actions: [
          IconButton(
            tooltip: strings.t('open_cockpit'),
            icon: const Icon(Icons.timeline),
            onPressed: () => Navigator.of(context).pushNamed(AppNavigation.routes['timeline.cockpit']!),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: routeController,
        builder: (context, _) {
          final history = routeController.history;
          if (history.isEmpty) {
            return Center(
              child: Text(
                strings.t('history_hint'),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final entry = history[index];
              return AnimatedEntry(
                delay: Duration(milliseconds: 80 * index),
                child: _HistoryCard(
                  entry: entry,
                  onLoad: () {
                    routeController.applyHistory(entry.id);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(strings.t('history_applied')),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: history.length,
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.entry, required this.onLoad});

  final RouteSummary entry;
  final VoidCallback onLoad;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isActive = entry.isActive;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
        boxShadow: [AppShadows.card],
        border: Border.all(color: isActive ? AppColors.limeDark : Colors.transparent, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: entry.status == 'delayed' ? AppColors.danger.withOpacity(0.12) : AppColors.limeSoft,
                  borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
                ),
                child: Text(
                  entry.status.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: entry.status == 'delayed' ? AppColors.danger : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _HistoryRow(
            icon: Icons.calendar_today,
            label: _formatDate(context, entry.date),
          ),
          _HistoryRow(
            icon: Icons.alt_route,
            label: '${formatNumber(entry.distanceMi)} ${strings.t('mi')} • ${formatNumber(entry.weightLb)} ${strings.t('lb')}',
          ),
          _HistoryRow(
            icon: Icons.check_circle,
            label: '${strings.t('on_time')}: ${(entry.onTimeRate * 100).toStringAsFixed(0)}% • ${entry.stops} ${strings.t('stops_count')}',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: onLoad,
                child: Text(strings.t('load_plan')),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(AppNavigation.routes['map.optimization']!),
                child: Text(strings.t('open_map')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final isArabic = AppLocalizations.of(context).isRtl;
    const monthsEn = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const monthsAr = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    final months = isArabic ? monthsAr : monthsEn;
    final month = months[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
