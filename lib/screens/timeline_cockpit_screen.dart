import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../core/app_scope.dart';
import '../core/design_system.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../widgets/animated_entry.dart';
import '../widgets/decorated_scaffold.dart';
import '../widgets/timeline_chart.dart';

class TimelineCockpitScreen extends StatelessWidget {
  const TimelineCockpitScreen({super.key, required this.routeController});

  final RouteController routeController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final vehicleController = AppScope.of(context).vehicleController;
    return DecoratedScaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: strings.t('search_schedule'),
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
          final plan = routeController.plan;
          final vehicleName = vehicleController.vehicle?.name ?? plan?.vehicleVin ?? 'Fleet';
          final formattedDate = _formatDate(plan?.date, strings);
          final nextStop = plan?.stops.isNotEmpty == true ? plan!.stops.first : null;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedEntry(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicleName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(formattedDate, style: Theme.of(context).textTheme.bodyMedium),
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
                ),
                const SizedBox(height: 20),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 160),
                  child: SizedBox(height: 260, child: TimelineChart(points: routeController.schedule)),
                ),
                const SizedBox(height: 20),
                if (nextStop != null)
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 220),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
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
                              children: [
                                Text(
                                  nextStop.code,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(nextStop.address, maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 8),
                                Text('${strings.t('status_awaiting')} • ${strings.t('eta_label')} ${nextStop.eta}'),
                              ],
                            ),
                          ),
                        ],
                      ),
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
            color: Theme.of(context).colorScheme.surface,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusMD.x),
        boxShadow: [AppShadows.soft],
      ),
      child: Icon(icon, color: AppColors.textPrimary),
    );
  }
}

String _formatDate(String? value, AppLocalizations strings) {
  if (value == null) {
    return '';
  }
  try {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    final monthsEn = [
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
      'Dec'
    ];
    final monthsAr = [
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
      'ديسمبر'
    ];
    final months = strings.isRtl ? monthsAr : monthsEn;
    final month = months[date.month - 1];
    return '${date.day} $month ${date.year}';
  } catch (_) {
    return value;
  }
}
