import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/devices_controller.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/schedule.dart';
import 'package:smart_home_control/widgets/gauge_control.dart';
import 'package:smart_home_control/widgets/mode_pills.dart';
import 'package:smart_home_control/widgets/schedule_row.dart';

class ClimateControlScreen extends StatefulWidget {
  const ClimateControlScreen({super.key, this.deviceId});

  final String? deviceId;

  @override
  State<ClimateControlScreen> createState() => _ClimateControlScreenState();
}

class _ClimateControlScreenState extends State<ClimateControlScreen> {
  late DevicesController _controller;
  Device? _device;
  String _mode = 'Cooling';
  Schedule? _schedule;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = ControllerScope.of(context).devices;
    _device = _controller.findById(widget.deviceId);
    if (_device != null && _device!.modes.isNotEmpty) {
      _mode = _device!.activeMode ?? _device!.modes.first;
    }
    _schedule ??= _controller.scheduleFor(_device?.id ?? '') ??
        _device?.schedule ??
        (_device == null
            ? null
            : Schedule(
                id: 'new_${_device!.id}',
                deviceId: _device!.id,
                enabled: true,
                start: '17:00',
                end: '18:20',
                repeat: const ['Mon'],
              ));
  }

  @override
  Widget build(BuildContext context) {
    if (_device == null) {
      return const Scaffold(body: Center(child: Text('Device not found')));
    }
    final schedule = _schedule!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate Control'),
        actions: [
          Switch(
            value: _device!.isOn,
            onChanged: (value) {
              _controller.toggleDevice(_device!.id, value);
              setState(() => _device = _device!.copyWith(isOn: value));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GaugeControl(
                  min: 16,
                  max: 35,
                  value: _device!.targetTemp ?? 24,
                  onChanged: (value) {
                    _controller.setTargetTemperature(_device!.id, value);
                    setState(() => _device = _device!.copyWith(targetTemp: value));
                  },
                ),
              ),
              const SizedBox(height: 16),
              ModePills(
                modes: _device!.modes.isEmpty
                    ? const ['Cooling', 'Dry', 'Heating', 'Fan']
                    : _device!.modes,
                active: _mode,
                onSelected: (mode) {
                  setState(() => _mode = mode);
                  _controller.setMode(_device!.id, mode);
                },
              ),
              const SizedBox(height: 20),
              Text('Schedule', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ScheduleRow(
                start: schedule.start,
                end: schedule.end,
                enabled: schedule.enabled,
                onChange: (enabled) async {
                  final updated = schedule.copyWith(enabled: enabled);
                  setState(() => _schedule = updated);
                  await _controller.updateSchedule(_device!.id, updated);
                },
                onPickTime: (isStart) => _pickTime(context, isStart),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () async {
              if (_schedule != null) {
                await _controller.updateSchedule(_device!.id, _schedule!);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ),
      ),
    );
}

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    if (_schedule == null) return;
    final initial = _parseTime(isStart ? _schedule!.start : _schedule!.end);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      final formatted = picked.format(context);
      setState(() {
        _schedule = isStart
            ? _schedule!.copyWith(start: formatted)
            : _schedule!.copyWith(end: formatted);
      });
      await _controller.updateSchedule(_device!.id, _schedule!);
    }
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1].replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return TimeOfDay.now();
  }
}
