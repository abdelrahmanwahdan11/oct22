import 'package:flutter/material.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/core/responsive.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/device_template.dart';
import 'package:smart_home_control/widgets/device_tile.dart';
import 'package:smart_home_control/widgets/search_bar.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final loc = scope.auth.localization;
    final listenable = Listenable.merge([scope.devices, scope.rooms, scope.auth, scope.settings]);
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final devices = scope.devices.devices;
        final statusFilter = scope.devices.statusFilter;
        final isGrid = scope.devices.isGridLayout;
        final settings = scope.settings;
        final showEnergy = settings.isEnhancementEnabled('energy_saver') ||
            settings.isEnhancementEnabled('energy_budget_guard');
        final showBattery = settings.isEnhancementEnabled('battery_watch');
        final showHealth = settings.isEnhancementEnabled('device_health');
        final budgetGuard = settings.isEnhancementEnabled('energy_budget_guard');
        return Scaffold(
          appBar: AppBar(
            title: Text(loc.t('devices')),
            actions: [
              IconButton(
                icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
                onPressed: () => scope.devices.setGridLayout(!isGrid),
              ),
            ],
          ),
          body: SafeArea(
            child: ResponsiveConstrainedBox(
              builder: (context, constraints) {
                final padding = AppBreakpoints.geometry(constraints.maxWidth);
                return Padding(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _openCatalog(context, scope),
                              icon: const Icon(Icons.add),
                              label: Text(loc.t('add_device')),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DeviceSearchBar(
                        hint: loc.t('search_device'),
                        onChanged: scope.devices.setSearch,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _StatusChip(
                            label: loc.t('filter_all'),
                            selected: statusFilter == DeviceStatusFilter.all,
                            onSelected: () => scope.devices.setStatusFilter(DeviceStatusFilter.all),
                          ),
                          _StatusChip(
                            label: loc.t('filter_online'),
                            selected: statusFilter == DeviceStatusFilter.online,
                            onSelected: () => scope.devices.setStatusFilter(DeviceStatusFilter.online),
                          ),
                          _StatusChip(
                            label: loc.t('filter_offline'),
                            selected: statusFilter == DeviceStatusFilter.offline,
                            onSelected: () => scope.devices.setStatusFilter(DeviceStatusFilter.offline),
                          ),
                          _StatusChip(
                            label: loc.t('filter_favorites'),
                            selected: statusFilter == DeviceStatusFilter.favorites,
                            onSelected: () => scope.devices.setStatusFilter(DeviceStatusFilter.favorites),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _DeviceSummaryCard(
                        title: loc.t('devices'),
                        subtitle: '${devices.length} ${loc.t('devices').toLowerCase()}',
                        budgetGuard: budgetGuard,
                        loc: loc,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: devices.isEmpty
                            ? Center(
                                child: Text(loc.t('no_devices_found')),
                              )
                            : isGrid
                                ? GridView.builder(
                                    itemCount: devices.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: AppBreakpoints.columns(
                                        constraints.maxWidth,
                                        compact: 2,
                                        medium: 3,
                                        expanded: 4,
                                      ),
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.95,
                                    ),
                                    itemBuilder: (context, index) {
                                      final device = devices[index];
                                      final energy = showEnergy ? scope.devices.energyEstimate(device) : null;
                                      final battery = showBattery
                                          ? 40 + device.id.hashCode.abs() % 60
                                          : null;
                                      final status = showHealth
                                          ? (device.isOn ? loc.t('device_health_ok') : loc.t('device_health_idle'))
                                          : loc.t(device.isOn ? 'status_on' : 'status_off');
                                      return DeviceTile(
                                        device: device,
                                        statusLabel: status,
                                        isFavorite: scope.devices.isFavorite(device.id),
                                        energyKwh: energy,
                                        batteryLevel: battery,
                                        onFavoriteToggle: () => scope.devices.toggleFavorite(device.id),
                                        onTap: () => _openDevice(context, device),
                                        onToggle: (value) => scope.devices.toggleDevice(device.id, value),
                                      );
                                    },
                                  )
                                : ListView.separated(
                                    itemCount: devices.length,
                                    itemBuilder: (context, index) {
                                      final device = devices[index];
                                      final energy = showEnergy ? scope.devices.energyEstimate(device) : null;
                                      final battery = showBattery
                                          ? 40 + device.id.hashCode.abs() % 60
                                          : null;
                                      final status = showHealth
                                          ? (device.isOn ? loc.t('device_health_ok') : loc.t('device_health_idle'))
                                          : loc.t(device.isOn ? 'status_on' : 'status_off');
                                      return DeviceTile(
                                        device: device,
                                        statusLabel: status,
                                        isFavorite: scope.devices.isFavorite(device.id),
                                        energyKwh: energy,
                                        batteryLevel: battery,
                                        onFavoriteToggle: () => scope.devices.toggleFavorite(device.id),
                                        onTap: () => _openDevice(context, device),
                                        onToggle: (value) => scope.devices.toggleDevice(device.id, value),
                                      );
                                    },
                                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _openDevice(BuildContext context, Device device) {
    Navigator.of(context).pushNamed(device.type.route, arguments: device.id);
  }

  Future<void> _openCatalog(BuildContext context, ControllerScope scope) async {
    final templates = scope.devices.catalog;
    final rooms = scope.rooms.allRooms;
    final loc = scope.auth.localization;
    if (templates.isEmpty || rooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.t('add_device_catalog'))),
      );
      return;
    }

    DeviceTemplate? selectedTemplate = templates.first;
    String selectedRoom = rooms.first.id;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.t('catalog_header'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.t('catalog_subtitle'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DeviceTemplate>(
                    value: selectedTemplate,
                    decoration: InputDecoration(labelText: loc.t('add_device_catalog')),
                    items: templates
                        .map(
                          (template) => DropdownMenuItem(
                            value: template,
                            child: Text(template.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedTemplate = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedRoom,
                    decoration: InputDecoration(labelText: loc.t('select_room')),
                    items: rooms
                        .map(
                          (room) => DropdownMenuItem(
                            value: room.id,
                            child: Text(room.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedRoom = value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(loc.t('cancel')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(loc.t('save')),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    if (confirmed == true) {
      final room = rooms.firstWhere((room) => room.id == selectedRoom);
      final device = await scope.devices.addFromTemplate(
        selectedTemplate,
        selectedRoom,
        roomName: room.name,
      );
      if (!context.mounted) return;
      final message = loc.t('device_added').replaceAll('{name}', device.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFFE6F3FF),
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? const Color(0xFF117BDB) : Theme.of(context).colorScheme.onSurface,
          ),
    );
  }
}

class _DeviceSummaryCard extends StatelessWidget {
  const _DeviceSummaryCard({
    required this.title,
    required this.subtitle,
    required this.budgetGuard,
    required this.loc,
  });

  final String title;
  final String subtitle;
  final bool budgetGuard;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2EA6FF), Color(0xFF117BDB)]),
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.devices_outlined, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (budgetGuard) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      loc.t('scene_budget_guard_notice'),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
