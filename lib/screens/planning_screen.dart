import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../core/design_system.dart';
import '../core/formatters.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../widgets/animated_entry.dart';
import '../widgets/assign_compartment_sheet.dart';
import '../widgets/decorated_scaffold.dart';
import '../widgets/floating_dot_menu.dart';
import '../widgets/metric_row.dart';
import '../widgets/stop_tile.dart';
import '../widgets/top_tabs.dart';
import '../widgets/toolbar_bottom.dart';
import '../widgets/truck_side_diagram.dart';
import '../widgets/view_mode_rail.dart';
import 'stop_detail_screen.dart' show StopDetailArgs;

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({
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
        title: Text(strings.t('planning')),
        actions: [
          IconButton(
            tooltip: strings.t('view_history'),
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).pushNamed(AppNavigation.routes['route.history']!),
          ),
          IconButton(
            tooltip: strings.t('view_orders_action'),
            icon: const Icon(Icons.inventory_2_outlined),
            onPressed: () => Navigator.of(context).pushNamed(AppNavigation.routes['route.suggestions']!),
          ),
          IconButton(
            tooltip: strings.t('settings'),
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).pushNamed(AppNavigation.routes['settings']!),
          ),
        ],
      ),
      bottomNavigationBar: ToolbarBottom(
        items: AppNavigation.toolbarItems,
        activeId: 'stops',
        onSelected: (id) => _handleBottomSelection(context, id),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([routeController, vehicleController]),
        builder: (context, _) {
          final vehicle = vehicleController.vehicle;
          final stops = routeController.stops;
          final compartments = vehicleController.compartments;
          final compartmentLabels = {
            for (final compartment in compartments) compartment.id: compartment.label,
          };
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedEntry(
                      child: TopTabs(
                        items: AppNavigation.topTabs.map((e) => strings.t(e.label.toLowerCase())).toList(),
                        selected: strings.t('planning'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (vehicle != null)
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 140),
                        child: isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: TruckSideDiagram(vehicle: vehicle)),
                                  const SizedBox(width: 24),
                                  const ViewModeRail(
                                    icons: ['truck_side', 'truck_top', 'truck_boxes'],
                                  ),
                                ],
                              )
                            : Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  TruckSideDiagram(vehicle: vehicle),
                                  const Positioned(
                                    right: -12,
                                    top: 16,
                                    child: ViewModeRail(
                                      icons: ['truck_side', 'truck_top', 'truck_boxes'],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    const SizedBox(height: 20),
                    if (vehicle != null)
                      AnimatedEntry(
                        delay: const Duration(milliseconds: 200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MetricRow(
                              metrics: [
                                MetricValue(label: 'VIN', value: vehicle.vin),
                                MetricValue(
                                  label: strings.t('distance'),
                                  value: '${formatNumber(vehicle.miles)} ${strings.t('mi')}',
                                ),
                                MetricValue(
                                  label: strings.t('weight_total'),
                                  value:
                                      '${formatNumber(routeController.totalWeight)} / ${formatNumber(vehicle.capacityLb)} ${strings.t('lb')}',
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton.icon(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(AppNavigation.routes['vehicle.overview']!),
                                icon: const Icon(Icons.dashboard_customize_outlined),
                                label: Text(strings.t('view_vehicle_overview')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    AnimatedEntry(
                      delay: const Duration(milliseconds: 220),
                      child: FloatingDotMenu(
                        onAction: (action) {
                          switch (action) {
                            case 'weight':
                              routeController.sortByWeight();
                              _showSnack(context, strings.t('sorted_by_weight'));
                              break;
                            case 'pallets':
                              routeController.sortByPallets();
                              _showSnack(context, strings.t('sorted_by_pallets'));
                              break;
                            case 'auto':
                              routeController.autoAssignStops();
                              _showSnack(context, strings.t('auto_assigned'));
                              break;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: stops.isEmpty
                          ? AnimatedEntry(
                              delay: const Duration(milliseconds: 260),
                              child: Center(
                                child: Text(
                                  strings.t('no_stops'),
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            )
                          : _StopsList(
                              stops: stops,
                              controller: routeController,
                              compartmentLabels: compartmentLabels,
                              onAssign: (stop) => _openAssignSheet(context, stop),
                              onShowDetails: (stop) => _openStopDetails(context, stop, fromSuggestions: false),
                              onShowReorderHint: () => _showSnack(context, strings.t('reorder_hint')),
                              onDelete: (stop) {
                                routeController.deleteStop(stop.id);
                                _showSnack(context, strings.t('deleted_stop'));
                              },
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

  void _handleBottomSelection(BuildContext context, String id) {
    switch (id) {
      case 'stops':
        break;
      case 'boxes':
        Navigator.of(context).pushReplacementNamed(AppNavigation.routes['distribution']!);
        break;
      case 'route':
        Navigator.of(context).pushReplacementNamed(AppNavigation.routes['statistics']!);
        break;
      case 'optimizer':
        Navigator.of(context).pushNamed(AppNavigation.routes['map.optimization']!);
        break;
    }
  }

  Future<void> _openAssignSheet(BuildContext context, Stop stop) async {
    final strings = AppLocalizations.of(context);
    final selection = await showAssignCompartmentSheet(
      context: context,
      compartments: vehicleController.compartments,
      stop: stop,
    );
    if (selection == null) {
      return;
    }
    if (selection == removeAssignmentValue) {
      routeController.removeStopAssignment(stop.id);
      _showSnack(context, strings.t('assignment_cleared'));
    } else {
      routeController.assignStopToCompartment(stop.id, selection);
      _showSnack(context, strings.t('assignment_updated'));
    }
  }

  void _openStopDetails(BuildContext context, Stop stop, {required bool fromSuggestions}) {
    Navigator.of(context).pushNamed(
      AppNavigation.routes['stop.detail']!,
      arguments: StopDetailArgs(stopId: stop.id, fromSuggestions: fromSuggestions),
    );
  }

  void _showSnack(BuildContext context, String message) {
    if (message.isEmpty) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _StopsList extends StatelessWidget {
  const _StopsList({
    required this.stops,
    required this.controller,
    required this.compartmentLabels,
    required this.onAssign,
    required this.onShowDetails,
    required this.onShowReorderHint,
    required this.onDelete,
  });

  final List<Stop> stops;
  final RouteController controller;
  final Map<String, String> compartmentLabels;
  final ValueChanged<Stop> onAssign;
  final ValueChanged<Stop> onShowDetails;
  final VoidCallback onShowReorderHint;
  final ValueChanged<Stop> onDelete;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: stops.length,
      onReorder: controller.reorderStops,
      buildDefaultDragHandles: false,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final stop = stops[index];
        return Padding(
          key: ValueKey(stop.id),
          padding: const EdgeInsets.only(bottom: 16),
          child: TweenAnimationBuilder<double>(
            duration: AppMotion.slow,
            curve: AppMotion.curve,
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 12),
                child: child,
              ),
            ),
            child: StopTile(
              stop: stop,
              assignedLabel: compartmentLabels[stop.lockedToCompartmentId],
              onToggleSelect: () => controller.toggleStopSelection(stop.id),
              onAssign: () => onAssign(stop),
              onTap: () => onShowDetails(stop),
              onActionSelected: (action) {
                switch (action) {
                  case 'assign':
                    onAssign(stop);
                    break;
                  case 'reorder':
                    onShowReorderHint();
                    break;
                  case 'delete':
                    onDelete(stop);
                    break;
                }
              },
              dragHandle: ReorderableDragStartListener(
                index: index,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.limeSoft,
                    borderRadius: BorderRadius.circular(AppRadii.radiusSM.x),
                  ),
                  child: const Icon(Icons.drag_indicator, color: AppColors.textPrimary),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
