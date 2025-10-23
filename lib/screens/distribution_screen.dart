import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../core/design_system.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../widgets/animated_entry.dart';
import '../widgets/assign_compartment_sheet.dart';
import '../widgets/compartment_card.dart';
import '../widgets/decorated_scaffold.dart';
import '../widgets/stop_tile.dart';
import '../widgets/top_tabs.dart';
import '../widgets/toolbar_bottom.dart';
import 'stop_detail_screen.dart' show StopDetailArgs;

class DistributionScreen extends StatelessWidget {
  const DistributionScreen({
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
        title: Text(strings.t('distribution')),
      ),
      extendBody: true,
      bottomNavigationBar: ToolbarBottom(
        items: AppNavigation.toolbarItems,
        activeId: 'boxes',
        onSelected: (id) => _handleBottomSelection(context, id),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([routeController, vehicleController]),
        builder: (context, _) {
          final compartments = vehicleController.compartments;
          final stops = routeController.stops;
          final compartmentLabels = {
            for (final compartment in compartments) compartment.id: compartment.label,
          };
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final crossAxisCount = isWide ? 3 : 2;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedEntry(
                          child: TopTabs(
                            items: AppNavigation.topTabs.map((e) => strings.t(e.label.toLowerCase())).toList(),
                            selected: strings.t('distribution'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: AnimatedEntry(
                            delay: const Duration(milliseconds: 160),
                            child: GridView.builder(
                              itemCount: compartments.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: isWide ? 1.2 : 1.05,
                              ),
                              itemBuilder: (context, index) {
                                final compartment = compartments[index];
                                return TweenAnimationBuilder<double>(
                                  duration: AppMotion.slow,
                                  curve: AppMotion.curve,
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) => Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, (1 - value) * 16),
                                      child: child,
                                    ),
                                  ),
                                  child: CompartmentCard(
                                    compartment: compartment,
                                    onAccept: (stopId) =>
                                        routeController.assignStopToCompartment(stopId, compartment.id),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedEntry(
                          delay: const Duration(milliseconds: 220),
                          child: Text(
                            strings.t('distribution_hint'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 180),
                      ],
                    ),
                  ),
                  _BottomStopsSheet(
                    stops: stops,
                    controller: routeController,
                    compartmentLabels: compartmentLabels,
                    onAssign: (stop) => _openAssignSheet(context, stop),
                    onShowDetails: (stop) => _openStopDetails(context, stop),
                  ),
                ],
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
        Navigator.of(context).pushReplacementNamed(AppNavigation.routes['planning']!);
        break;
      case 'boxes':
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

  void _openStopDetails(BuildContext context, Stop stop) {
    Navigator.of(context).pushNamed(
      AppNavigation.routes['stop.detail']!,
      arguments: StopDetailArgs(stopId: stop.id, fromSuggestions: false),
    );
  }

  void _showSnack(BuildContext context, String message) {
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

class _BottomStopsSheet extends StatelessWidget {
  const _BottomStopsSheet({
    required this.stops,
    required this.controller,
    required this.compartmentLabels,
    required this.onAssign,
    required this.onShowDetails,
  });

  final List<Stop> stops;
  final RouteController controller;
  final Map<String, String> compartmentLabels;
  final ValueChanged<Stop> onAssign;
  final ValueChanged<Stop> onShowDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.15,
      maxChildSize: 0.55,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: AppRadii.radiusXXL),
            boxShadow: [AppShadows.card],
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context).t('stops'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Text('${stops.length}'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: stops.length,
                  itemBuilder: (context, index) {
                    final stop = stops[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LongPressDraggable<String>(
                        data: stop.id,
                        feedback: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 80,
                            child: StopTile(
                              stop: stop,
                              assignedLabel: compartmentLabels[stop.lockedToCompartmentId],
                              showAssignButton: false,
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: StopTile(
                            stop: stop,
                            assignedLabel: compartmentLabels[stop.lockedToCompartmentId],
                            showAssignButton: false,
                          ),
                        ),
                        child: StopTile(
                          stop: stop,
                          assignedLabel: compartmentLabels[stop.lockedToCompartmentId],
                          onToggleSelect: () => controller.toggleStopSelection(stop.id),
                          onAssign: () => onAssign(stop),
                          onTap: () => onShowDetails(stop),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
