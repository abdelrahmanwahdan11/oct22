import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../core/design_system.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../widgets/animated_entry.dart';
import '../widgets/assign_compartment_sheet.dart';
import '../widgets/decorated_scaffold.dart';
import '../widgets/stop_tile.dart';

class StopDetailArgs {
  const StopDetailArgs({required this.stopId, required this.fromSuggestions});

  final String stopId;
  final bool fromSuggestions;
}

class StopDetailScreen extends StatelessWidget {
  const StopDetailScreen({
    super.key,
    required this.routeController,
    required this.vehicleController,
    required this.args,
  });

  final RouteController routeController;
  final VehicleController vehicleController;
  final StopDetailArgs args;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return DecoratedScaffold(
      appBar: AppBar(
        title: Text(strings.t('stop_details')),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([routeController, vehicleController]),
        builder: (context, _) {
          final stop = routeController.findStopById(args.stopId, includeSuggestions: true);
          if (stop == null) {
            return Center(
              child: Text(
                strings.t('stop_not_found'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          final inPlan = routeController.stops.any((element) => element.id == stop.id);
          final assignedLabel = vehicleController.labelForCompartment(stop.lockedToCompartmentId);
          final fromSuggestions = args.fromSuggestions;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedEntry(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/map_base.jpg',
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.limeSoft,
                              borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
                            ),
                            child: Text('${strings.t('eta_label')} ${stop.eta}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 160),
                  child: StopTile(
                    stop: stop,
                    assignedLabel: assignedLabel,
                    showAssignButton: false,
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 220),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _InfoChip(label: '${strings.t('pallets')}: ${stop.pallets}'),
                      _InfoChip(label: '${strings.t('weight_total')}: ${stop.weightLb} ${strings.t('lb')}'),
                      _InfoChip(label: '${strings.t('distance')}: ${routeController.plan?.distanceMi ?? 0} ${strings.t('mi')}'),
                      if (assignedLabel != null)
                        _InfoChip(label: '${strings.t('compartment')} $assignedLabel'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 260),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _buildActions(context, stop, inPlan, fromSuggestions),
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedEntry(
                  delay: const Duration(milliseconds: 320),
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed(AppNavigation.routes['map.optimization']!),
                    icon: const Icon(Icons.map_outlined),
                    label: Text(strings.t('open_map')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, Stop stop, bool inPlan, bool fromSuggestions) {
    final strings = AppLocalizations.of(context);
    final actions = <Widget>[];
    if (inPlan) {
      actions.add(
        ElevatedButton.icon(
          onPressed: () => _assignStop(context, stop),
          icon: const Icon(Icons.inventory_2_outlined),
          label: Text(strings.t('assign_stop')),
        ),
      );
      actions.add(
        OutlinedButton(
          onPressed: () {
            routeController.toggleStopSelection(stop.id);
            _showSnack(context, strings.t('selection_updated'));
          },
          child: Text(stop.selected ? strings.t('mark_unselected') : strings.t('mark_selected')),
        ),
      );
      if (stop.lockedToCompartmentId != null) {
        actions.add(
          TextButton(
            onPressed: () {
              routeController.removeStopAssignment(stop.id);
              _showSnack(context, strings.t('assignment_cleared'));
            },
            child: Text(strings.t('remove_assignment')),
          ),
        );
      }
    } else if (fromSuggestions) {
      actions.add(
        ElevatedButton.icon(
          onPressed: () {
            if (routeController.stops.any((element) => element.id == stop.id)) {
              _showSnack(context, strings.t('already_in_plan'));
              return;
            }
            routeController.addSuggestedStop(stop);
            _showSnack(context, strings.t('added_stop'));
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.add_task),
          label: Text(strings.t('add_to_plan')),
        ),
      );
    }
    return actions;
  }

  Future<void> _assignStop(BuildContext context, Stop stop) async {
    final selection = await showAssignCompartmentSheet(
      context: context,
      compartments: vehicleController.compartments,
      stop: stop,
    );
    final strings = AppLocalizations.of(context);
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.limeSoft,
        borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
      ),
      child: Text(label),
    );
  }
}
