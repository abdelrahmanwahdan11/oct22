import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../core/app_scope.dart';
import '../core/design_system.dart';
import '../l10n/app_localizations.dart';
import '../widgets/animated_entry.dart';
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
    final vehicle = AppScope.of(context).vehicleController.vehicle;
    return DecoratedScaffold(
      appBar: AppBar(
        title: Text(vehicle?.name ?? routeController.plan?.vehicleVin ?? 'Route'),
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
                AnimatedEntry(
                  child: AspectRatio(
                    aspectRatio: 16 / 12,
                    child: MapCanvas(stops: stops),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 160),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _MetricBadge(label: strings.t('arrival_at'), value: '01:37'),
                      _MetricBadge(label: strings.t('delay'), value: '+46 min', highlight: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
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
                ),
                const SizedBox(height: 20),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 260),
                  child: OptimizationCard(
                    points: routeController.optimizationPoints,
                    moneyDelta: 1100,
                    milesDelta: 7,
                  ),
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
          color: Theme.of(context).colorScheme.surface,
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.limeSoft
            : theme.colorScheme.surface.withOpacity(theme.brightness == Brightness.dark ? 0.9 : 1),
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
