import 'package:flutter/material.dart';

import '../controllers/route_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../widgets/compartment_card.dart';
import '../widgets/decorated_scaffold.dart';
import '../widgets/stop_tile.dart';
import '../widgets/top_tabs.dart';
import '../widgets/toolbar_bottom.dart';

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
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopTabs(
                      items: AppNavigation.topTabs.map((e) => strings.t(e.label.toLowerCase())).toList(),
                      selected: strings.t('distribution'),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        itemCount: compartments.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        itemBuilder: (context, index) {
                          final compartment = compartments[index];
                          return CompartmentCard(
                            compartment: compartment,
                            onAccept: (stopId) => routeController.assignStopToCompartment(stopId, compartment.id),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'اسحب StopTile من القائمة السفلية وأسقطه داخل مقصورة لتوزيع الحمولة.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 180),
                  ],
                ),
              ),
              _BottomStopsSheet(stops: stops, controller: routeController),
            ],
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
}

class _BottomStopsSheet extends StatelessWidget {
  const _BottomStopsSheet({required this.stops, required this.controller});

  final List<Stop> stops;
  final RouteController controller;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.15,
      maxChildSize: 0.55,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Color(0x14101828),
                blurRadius: 30,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black12,
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
                            child: StopTile(stop: stop),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: StopTile(stop: stop),
                        ),
                        child: StopTile(
                          stop: stop,
                          onToggleSelect: () => controller.toggleStopSelection(stop.id),
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
