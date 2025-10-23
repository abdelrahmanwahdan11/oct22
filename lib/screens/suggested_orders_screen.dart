import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../core/design_system.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../widgets/animated_entry.dart';
import '../widgets/decorated_scaffold.dart';
import '../widgets/stop_tile.dart';
import 'stop_detail_screen.dart' show StopDetailArgs;

class SuggestedOrdersScreen extends StatelessWidget {
  const SuggestedOrdersScreen({super.key, required this.routeController});

  final RouteController routeController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return DecoratedScaffold(
      appBar: AppBar(
        title: Text(strings.t('suggested_orders')),
        actions: [
          IconButton(
            tooltip: strings.t('view_history_action'),
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).pushNamed(AppNavigation.routes['route.history']!),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: routeController,
        builder: (context, _) {
          final orders = routeController.suggestedStops;
          if (orders.isEmpty) {
            return Center(
              child: Text(
                strings.t('empty_orders'),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length + 1,
            separatorBuilder: (_, index) => index == 0 ? const SizedBox(height: 24) : const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == 0) {
                return AnimatedEntry(
                  child: Text(
                    strings.t('orders_backlog_hint'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                );
              }
              final stop = orders[index - 1];
              return AnimatedEntry(
                delay: Duration(milliseconds: 100 * index),
                child: _OrderCard(
                  stop: stop,
                  onAdd: () {
                    routeController.addSuggestedStop(stop);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(strings.t('added_stop')),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                  onDetails: () => Navigator.of(context).pushNamed(
                    AppNavigation.routes['stop.detail']!,
                    arguments: StopDetailArgs(stopId: stop.id, fromSuggestions: true),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.stop, required this.onAdd, required this.onDetails});

  final Stop stop;
  final VoidCallback onAdd;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StopTile(
          stop: stop,
          showAssignButton: false,
          onTap: onDetails,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.playlist_add),
              label: Text(strings.t('add_to_plan')),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: onDetails,
              child: Text(strings.t('details')),
            ),
          ],
        ),
      ],
    );
  }
}
