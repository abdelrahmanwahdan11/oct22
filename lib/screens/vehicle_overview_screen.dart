import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../core/design_system.dart';
import '../l10n/app_localizations.dart';
import '../widgets/animated_entry.dart';
import '../widgets/decorated_scaffold.dart';

class VehicleOverviewScreen extends StatelessWidget {
  const VehicleOverviewScreen({
    super.key,
    required this.vehicleController,
    required this.routeController,
  });

  final VehicleController vehicleController;
  final RouteController routeController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return DecoratedScaffold(
      appBar: AppBar(
        title: Text(strings.t('vehicle_overview')),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([vehicleController, routeController]),
        builder: (context, _) {
          final vehicle = vehicleController.vehicle;
          if (vehicle == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final compartments = vehicleController.compartments;
          final utilization = vehicle.currentLb / vehicle.capacityLb;
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 860;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedEntry(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
                          boxShadow: [AppShadows.card],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vehicle.name} • ${vehicle.vin}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            Text('${strings.t('distance')}: ${routeController.plan?.distanceMi ?? vehicle.miles} ${strings.t('mi')}'),
                            Text('${strings.t('weight_total')}: ${vehicle.currentLb}/${vehicle.capacityLb} ${strings.t('lb')}'),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: utilization.clamp(0.0, 1.0),
                              backgroundColor: AppColors.border,
                              color: AppColors.limeDark,
                              minHeight: 12,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(utilization * 100).toStringAsFixed(0)}% ${strings.t('utilization')}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedEntry(
                      delay: const Duration(milliseconds: 180),
                      child: Text(
                        strings.t('compartments'),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedEntry(
                      delay: const Duration(milliseconds: 220),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: compartments.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide ? 3 : 1,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isWide ? 1.4 : 3.6,
                        ),
                        itemBuilder: (context, index) {
                          final compartment = compartments[index];
                          final percent = compartment.utilization * 100;
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
                              boxShadow: [AppShadows.soft],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${strings.t('compartment')} ${compartment.label}',
                                      style:
                                          Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    Text('${compartment.currentLb}/${compartment.capacityLb} ${strings.t('lb')}'),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value: compartment.utilization.clamp(0.0, 1.0),
                                  color: AppColors.limeDark,
                                  backgroundColor: AppColors.border,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${percent.toStringAsFixed(0)}% ${strings.t('utilization')}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedEntry(
                      delay: const Duration(milliseconds: 260),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.limeSoft,
                          borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
                        ),
                        child: Text(
                          strings.t('orders_backlog_hint'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
