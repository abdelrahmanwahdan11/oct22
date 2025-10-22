import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/devices_controller.dart';
import 'package:smart_home_control/controllers/energy_controller.dart';
import 'package:smart_home_control/controllers/rooms_controller.dart';
import 'package:smart_home_control/controllers/settings_controller.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/core/feature_catalog.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/room.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

class FeatureHighlights extends StatefulWidget {
  const FeatureHighlights({
    super.key,
    required this.settings,
    required this.devices,
    required this.rooms,
    required this.energy,
    required this.localization,
  });

  final SettingsController settings;
  final DevicesController devices;
  final RoomsController rooms;
  final EnergyController energy;
  final AppLocalizations localization;

  @override
  State<FeatureHighlights> createState() => _FeatureHighlightsState();
}

class _FeatureHighlightsState extends State<FeatureHighlights> {
  late final PageController _controller;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88)
      ..addListener(() {
        setState(() => _page = _controller.page ?? _controller.initialPage.toDouble());
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeIds = widget.settings.activeEnhancementIds.toSet();
    if (activeIds.isEmpty) {
      return const SizedBox.shrink();
    }
    final options = enhancementCatalog
        .where((option) => activeIds.contains(option.id))
        .take(12)
        .toList();
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            widget.localization.t('room_carousel_enhancements'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 164,
          child: PageView.builder(
            controller: _controller,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isActive = (_page - index).abs() < 0.5;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedReveal(
                  delayFactor: index,
                  child: AnimatedContainer(
                    duration: AppMotion.base,
                    curve: AppMotion.curve,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isActive
                            ? [
                                Theme.of(context).colorScheme.primary.withOpacity(0.18),
                                Theme.of(context).colorScheme.primary.withOpacity(0.06),
                              ]
                            : [
                                Theme.of(context).colorScheme.surface,
                                Theme.of(context).colorScheme.surface.withOpacity(0.94),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: _FeatureCardContent(
                      option: option,
                      loc: widget.localization,
                      metrics: _buildMetrics(option),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < options.length; i++)
              AnimatedContainer(
                duration: AppMotion.fast,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: (_page - i).abs() < 0.5 ? 18 : 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity((_page - i).abs() < 0.5 ? 0.8 : 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ],
    );
  }

  List<_Metric> _buildMetrics(EnhancementOption option) {
    final rooms = widget.rooms.rooms;
    final devices = widget.devices.devices;
    final activeDevices = devices.where((device) => device.isOn).length;
    final climateDevices = devices.where((device) => device.type == 'climate').length;
    final lightDevices = devices.where((device) => device.type == 'light').length;
    final cameras = devices.where((device) => device.type == 'camera').length;
    final energyToday = widget.energy.points.isEmpty
        ? 0
        : widget.energy.points.first.kwh;

    switch (option.id) {
      case 'energy_budget_guard':
      case 'energy_saver':
      case 'eco_challenge':
      case 'solar_forecast':
        return [
          _Metric(icon: Icons.bolt, label: '${energyToday} kWh'),
          _Metric(icon: Icons.savings_outlined, label: '${math.max(1, rooms.length)} ${widget.localization.t('label_rooms_generic')}'),
        ];
      case 'mood_lighting':
      case 'ambient_music':
      case 'night_lighting':
      case 'auto_shades':
        return [
          _Metric(icon: Icons.emoji_objects, label: lightDevices.toString()),
          _Metric(icon: Icons.schedule, label: '${widget.devices.scheduleCount}'),
        ];
      case 'scene_orchestrator':
      case 'dynamic_dashboard':
        return [
          _Metric(icon: Icons.auto_awesome_motion, label: '${rooms.length}'),
          _Metric(icon: Icons.power_settings_new, label: '$activeDevices/${devices.length}'),
        ];
      case 'climate_equalizer':
      case 'microclimate_zones':
        return [
          _Metric(icon: Icons.thermostat, label: climateDevices.toString()),
          _Metric(icon: Icons.air, label: '${widget.rooms.rooms.map((room) => room.temperature).fold<int>(0, (sum, temp) => sum + temp) ~/ math.max(1, rooms.length)}°C'),
        ];
      case 'adaptive_security':
      case 'garage_guard':
      case 'doorbell_ai':
      case 'privacy_mode':
        return [
          _Metric(icon: Icons.videocam, label: cameras.toString()),
          _Metric(icon: Icons.shield, label: '${widget.devices.sceneCount}'),
        ];
      default:
        return [
          _Metric(icon: Icons.home, label: rooms.length.toString()),
          _Metric(icon: Icons.devices, label: devices.length.toString()),
        ];
    }
  }
}

class _FeatureCardContent extends StatelessWidget {
  const _FeatureCardContent({
    required this.option,
    required this.loc,
    required this.metrics,
  });

  final EnhancementOption option;
  final AppLocalizations loc;
  final List<_Metric> metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(option.icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.t(option.titleKey),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.t(option.subtitleKey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final metric in metrics)
              Chip(
                avatar: Icon(metric.icon, size: 14),
                label: Text(metric.label),
              ),
          ],
        ),
      ],
    );
  }
}

class _Metric {
  const _Metric({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
