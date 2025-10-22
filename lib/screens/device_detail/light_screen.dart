import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/devices_controller.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/schedule.dart';
import 'package:smart_home_control/widgets/schedule_row.dart';

class LightControlScreen extends StatefulWidget {
  const LightControlScreen({super.key, this.deviceId});

  final String? deviceId;

  @override
  State<LightControlScreen> createState() => _LightControlScreenState();
}

class _LightControlScreenState extends State<LightControlScreen> {
  double _intensity = 0.6;
  late DevicesController _controller;
  Device? _device;
  Schedule? _schedule;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = ControllerScope.of(context).devices;
    _device = _controller.findById(widget.deviceId);
    _schedule ??= _controller.scheduleFor(widget.deviceId ?? '') ??
        _device?.schedule ??
        (_device == null
            ? null
            : Schedule(
                id: 'light_${_device!.id}',
                deviceId: _device!.id,
                enabled: true,
                start: '7:00 PM',
                end: '2:00 AM',
                repeat: const ['Daily'],
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
        title: const Text('Smart Light'),
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
                child: Hero(
                  tag: 'device_image_${_device!.id}',
                  child: Image.asset(
                    _device!.image,
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Intensity', style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: _intensity,
                min: 0,
                max: 1,
                onChanged: (value) => setState(() => _intensity = value),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: const [
                  _ModeChip(label: 'Prayer'),
                  _ModeChip(label: 'Night'),
                  _ModeChip(label: 'Movie'),
                  _ModeChip(label: 'Party'),
                ],
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
    );
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    if (_schedule == null) return;
    final initial = _parseTime(isStart ? _schedule!.start : _schedule!.end);
    final picked = await showTimePicker(context: context, initialTime: initial);
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

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EAF0)),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
