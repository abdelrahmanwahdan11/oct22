import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../core/design_system.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../widgets/animated_entry.dart';
import '../widgets/decorated_scaffold.dart';
import '../widgets/stats_bars.dart';
import '../widgets/timeline_chart.dart';
import '../widgets/top_tabs.dart';
import '../widgets/toolbar_bottom.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({
    super.key,
    required this.routeController,
    required this.vehicleController,
  });

  final RouteController routeController;
  final VehicleController vehicleController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return DecoratedScaffold(
      appBar: AppBar(
        title: Text(strings.t('statistics')),
      ),
      bottomNavigationBar: ToolbarBottom(
        items: AppNavigation.toolbarItems,
        activeId: 'route',
        onSelected: (id) => _handleBottomSelection(context, id),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([routeController, vehicleController]),
        builder: (context, _) {
          final vehicle = vehicleController.vehicle;
          final statsData = [
            StatsBarData(
              label: strings.t('weight'),
              value: routeController.totalWeight.toDouble(),
              valueLabel: '${routeController.totalWeight} ${strings.t('lb')}',
            ),
            StatsBarData(
              label: strings.t('pallets'),
              value: routeController.totalPallets.toDouble(),
              valueLabel: routeController.totalPallets.toString(),
            ),
            StatsBarData(
              label: strings.t('stops_count'),
              value: routeController.stops.length.toDouble(),
              valueLabel: routeController.stops.length.toString(),
            ),
          ];
          return Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedEntry(
                        child: TopTabs(
                          items: AppNavigation.topTabs.map((e) => strings.t(e.label.toLowerCase())).toList(),
                          selected: strings.t('statistics'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 120),
                        child: Text(
                          strings.t('utilization'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 180),
                        child: StatsBars(data: statsData),
                      ),
                      const SizedBox(height: 20),
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 220),
                        child: Text(
                          strings.t('timeline_title'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 260),
                        child: SizedBox(
                          height: isWide ? 320 : 260,
                          child: TimelineChart(points: routeController.schedule),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 300),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed(AppNavigation.routes['timeline.cockpit']!),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.lime),
                            child: Text(strings.t('open_cockpit')),
                          ),
                        ),
                      ),
                      if (vehicle != null) ...[
                        const SizedBox(height: 24),
                        AnimatedEntry(
                          delay: const Duration(milliseconds: 340),
                          child: Text('VIN ${vehicle.vin} • ${vehicle.name}'),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleBottomSelection(BuildContext context, String id) {
    switch (id) {
      case 'stops':
        Navigator.of(context).pushReplacementNamed(AppNavigation.routes['planning']!);
        break;
      case 'boxes':
        Navigator.of(context).pushReplacementNamed(AppNavigation.routes['distribution']!);
        break;
      case 'route':
        break;
      case 'optimizer':
        Navigator.of(context).pushNamed(AppNavigation.routes['map.optimization']!);
        break;
    }
  }
}
