import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/devices_controller.dart';
import 'package:smart_home_control/controllers/rooms_controller.dart';
import 'package:smart_home_control/controllers/settings_controller.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/room.dart';
import 'package:smart_home_control/widgets/animated_reveal.dart';

class RoomsCarouselScreen extends StatefulWidget {
  const RoomsCarouselScreen({super.key});

  @override
  State<RoomsCarouselScreen> createState() => _RoomsCarouselScreenState();
}

class _RoomsCarouselScreenState extends State<RoomsCarouselScreen> {
  late final PageController _controller;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.92)
      ..addListener(() {
        setState(() => _page = _controller.page ?? 0);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final listenable = Listenable.merge([
      scope.rooms,
      scope.devices,
      scope.settings,
      scope.auth,
      scope.energy,
    ]);

    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final roomsController = scope.rooms;
        final devicesController = scope.devices;
        final settings = scope.settings;
        final loc = scope.auth.localization;
        final rooms = roomsController.rooms;
        final colors = _paletteForTheme(Theme.of(context).brightness);
        return Scaffold(
          appBar: AppBar(
            title: Text(loc.t('room_carousel_title')),
            actions: [
              IconButton(
                onPressed: () {
                  final newIndex = ((_controller.page ?? 0) + 1).round() % math.max(1, rooms.length);
                  _controller.animateToPage(
                    newIndex,
                    duration: AppMotion.base,
                    curve: AppMotion.curve,
                  );
                },
                icon: const Icon(Icons.skip_next),
              ),
            ],
          ),
          body: SafeArea(
            child: rooms.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        loc.t('room_carousel_empty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
                        child: Text(
                          loc.t('room_carousel_hint'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            final room = rooms[index];
                            final ratio = (index - _page).abs().clamp(0, 1);
                            final colorPair = colors[index % colors.length];
                            final devices = devicesController.allDevices
                                .where((device) => device.roomId == room.id)
                                .toList();
                            return AnimatedReveal(
                              delayFactor: index,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                child: _RoomInsightCard(
                                  room: room,
                                  devices: devices,
                                  settings: settings,
                                  devicesController: devicesController,
                                  loc: loc,
                                  accent: Color.lerp(colorPair.$1, colorPair.$2, 1 - ratio) ?? colorPair.$1,
                                  secondary: Color.lerp(colorPair.$2, colorPair.$1, ratio) ?? colorPair.$2,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < rooms.length; i++)
                            AnimatedContainer(
                              duration: AppMotion.fast,
                              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                              height: 6,
                              width: (_page - i).abs() < 0.5 ? 22 : 10,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity((_page - i).abs() < 0.5 ? 0.8 : 0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
          ),
        );
      },
    );
  }

  List<(Color, Color)> _paletteForTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const [
        (Color(0xFF1F2937), Color(0xFF111827)),
        (Color(0xFF0F172A), Color(0xFF1E293B)),
        (Color(0xFF1E3A5F), Color(0xFF112240)),
      ];
    }
    return const [
      (Color(0xFFE6F3FF), Color(0xFF117BDB)),
      (Color(0xFFFEECEB), Color(0xFFF04438)),
      (Color(0xFFE9F8EF), Color(0xFF2EC36A)),
      (Color(0xFFFFF4E5), Color(0xFFFDB022)),
    ];
  }
}

class _RoomInsightCard extends StatelessWidget {
  const _RoomInsightCard({
    required this.room,
    required this.devices,
    required this.settings,
    required this.devicesController,
    required this.loc,
    required this.accent,
    required this.secondary,
  });

  final Room room;
  final List<Device> devices;
  final SettingsController settings;
  final DevicesController devicesController;
  final AppLocalizations loc;
  final Color accent;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalEnergy = devices.fold<double>(0, (sum, device) => sum + devicesController.energyEstimate(device));
    final onDevices = devices.where((device) => device.isOn).length;
    final hasMood = settings.isEnhancementEnabled('mood_lighting');
    final hasScene = settings.isEnhancementEnabled('scene_orchestrator');
    final hasEco = settings.isEnhancementEnabled('eco_challenge');
    return AnimatedContainer(
      duration: AppMotion.slow,
      curve: AppMotion.curve,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, secondary.withOpacity(0.92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: secondary.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${room.devicesActive}/${room.devicesTotal} ${loc.t('label_devices_generic')}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: AppMotion.base,
                curve: AppMotion.curve,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${room.temperature}°C',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _InsightChip(
                icon: Icons.bolt,
                label: '${totalEnergy.toStringAsFixed(0)} kWh',
                title: loc.t('room_carousel_energy_today'),
              ),
              _InsightChip(
                icon: Icons.thermostat,
                label: '${room.temperature}°C',
                title: loc.t('room_carousel_comfort'),
              ),
              _InsightChip(
                icon: Icons.light_mode,
                label: '$onDevices/${devices.length}',
                title: loc.t('room_carousel_devices'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: math.min(4, devices.length),
              itemBuilder: (context, index) {
                final device = devices[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AnimatedReveal(
                    delayFactor: index,
                    child: _DeviceInsightRow(device: device, loc: loc),
                  ),
                );
              },
            ),
          ),
          if (hasMood || hasScene || hasEco) ...[
            const SizedBox(height: 12),
            Text(
              loc.t('room_carousel_enhancements'),
              style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (hasMood)
                  Chip(
                    label: Text(loc.t('feature_mood_lighting_chip')),
                    avatar: const Icon(Icons.emoji_objects, size: 16),
                    backgroundColor: Colors.white12,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                if (hasScene)
                  Chip(
                    label: Text(loc.t('feature_scene_orchestrator_chip')),
                    avatar: const Icon(Icons.auto_awesome_motion, size: 16),
                    backgroundColor: Colors.white12,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                if (hasEco)
                  Chip(
                    label: Text(loc.t('feature_eco_challenge_chip')),
                    avatar: const Icon(Icons.emoji_events_outlined, size: 16),
                    backgroundColor: Colors.white12,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _applyScene(context),
            icon: const Icon(Icons.play_arrow),
            label: Text(loc.t('room_carousel_scene')),
          ),
        ],
      ),
    );
  }

  Future<void> _applyScene(BuildContext context) async {
    final scope = ControllerScope.of(context);
    final devices = scope.devices;
    final loc = scope.auth.localization;
    final key = await devices.applyScene('movie');
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.t(key))),
    );
  }
}

class _InsightChip extends StatelessWidget {
  const _InsightChip({required this.icon, required this.label, required this.title});

  final IconData icon;
  final String label;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: AppMotion.base,
      curve: AppMotion.curve,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _DeviceInsightRow extends StatelessWidget {
  const _DeviceInsightRow({required this.device, required this.loc});

  final Device device;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.curve,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'device_image_${device.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(device.image, width: 46, height: 46, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  loc.t(device.isOn ? 'status_on' : 'status_off'),
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Switch(
            value: device.isOn,
            onChanged: (value) => ControllerScope.of(context).devices.toggleDevice(device.id, value),
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
