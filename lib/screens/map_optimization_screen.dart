import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../core/design_system.dart';
import '../l10n/app_localizations.dart';
import '../widgets/decorated_scaffold.dart';
import '../widgets/map_canvas.dart';
import '../widgets/optimization_card.dart';

class MapOptimizationScreen extends StatelessWidget {
  const MapOptimizationScreen({
    super.key,
    required this.routeController,
  });

  final RouteController routeController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return DecoratedScaffold(
      appBar: AppBar(
        title: const Text('UTD38723'),
      ),
      body: AnimatedBuilder(
        animation: routeController,
        builder: (context, _) {
          final stops = routeController.stops;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MapCanvas(stops: stops),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: [
                    _MetricBadge(label: strings.t('arrival_at'), value: '01:37'),
                    _MetricBadge(label: strings.t('delay'), value: '+46 min', highlight: true),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
                    boxShadow: [AppShadows.soft],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('00:00'),
                      Text('06:00'),
                      Text('12:00'),
                      Text('18:00'),
                      Text('24:00'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                OptimizationCard(
                  points: routeController.optimizationPoints,
                  moneyDelta: 1100,
                  milesDelta: 7,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: AppRadii.radiusXXL),
          boxShadow: [AppShadows.card],
        ),
        child: Text(strings.t('drag_more')),
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlight ? AppColors.limeSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
        boxShadow: highlight ? [AppShadows.soft] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
