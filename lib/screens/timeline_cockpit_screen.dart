import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../core/design_system.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../widgets/decorated_scaffold.dart';
import '../widgets/timeline_chart.dart';

class TimelineCockpitScreen extends StatelessWidget {
  const TimelineCockpitScreen({super.key, required this.routeController});

  final RouteController routeController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return DecoratedScaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search schedule',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.notifications_active_outlined),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: routeController,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'PB-LP-PB Scenario',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 4),
                        Text('Friday, Dec 20, 2025'),
                      ],
                    ),
                    Row(
                      children: const [
                        _HeaderIcon(icon: Icons.calendar_today),
                        SizedBox(width: 12),
                        _HeaderIcon(icon: Icons.settings),
                        SizedBox(width: 12),
                        _HeaderIcon(icon: Icons.refresh),
                        SizedBox(width: 12),
                        _HeaderIcon(icon: Icons.more_horiz),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TimelineChart(points: routeController.schedule),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
                    boxShadow: [AppShadows.card],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadii.radiusMD.x),
                        child: Image.asset(
                          'assets/images/truck_side.png',
                          width: 96,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'UTD38723',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 4),
                            Text('2464 Royal Ln, Mesa'),
                            SizedBox(height: 8),
                            Text('Awaiting • ETA 01:37'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
            boxShadow: [AppShadows.card],
          ),
          child: Row(
            children: [
              const _HeaderIcon(icon: Icons.grid_view),
              const SizedBox(width: 12),
              const _HeaderIcon(icon: Icons.layers_outlined),
              const SizedBox(width: 12),
              const _HeaderIcon(icon: Icons.bolt),
              const SizedBox(width: 12),
              const _HeaderIcon(icon: Icons.delete_outline),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(AppNavigation.routes['map.optimization']!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lime,
                  foregroundColor: AppColors.textPrimary,
                ),
                child: Text(strings.t('optimizer')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusMD.x),
        boxShadow: [AppShadows.soft],
      ),
      child: Icon(icon, color: AppColors.textPrimary),
    );
  }
}
