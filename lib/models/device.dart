import 'package:smart_home_control/models/schedule.dart';

enum DeviceType { climate, camera, light, robot, speaker, cleaner, other }

class Device {
  const Device({
    required this.id,
    required this.name,
    required this.type,
    required this.roomId,
    required this.image,
    required this.isOn,
    this.modes = const [],
    this.temperature,
    this.targetTemp,
    this.schedule,
    this.activeMode,
  });

  final String id;
  final String name;
  final DeviceType type;
  final String roomId;
  final String image;
  final bool isOn;
  final List<String> modes;
  final double? temperature;
  final double? targetTemp;
  final Schedule? schedule;
  final String? activeMode;

  Device copyWith({
    bool? isOn,
    double? temperature,
    double? targetTemp,
    Schedule? schedule,
    String? activeMode,
  }) {
    return Device(
      id: id,
      name: name,
      type: type,
      roomId: roomId,
      image: image,
      isOn: isOn ?? this.isOn,
      modes: modes,
      temperature: temperature ?? this.temperature,
      targetTemp: targetTemp ?? this.targetTemp,
      schedule: schedule ?? this.schedule,
      activeMode: activeMode ?? this.activeMode,
    );
  }
}

extension DeviceTypeX on DeviceType {
  String get route {
    switch (this) {
      case DeviceType.climate:
        return 'device.climate';
      case DeviceType.camera:
        return 'device.camera';
      case DeviceType.light:
        return 'device.light';
      default:
        return 'devices.list';
    }
  }
}
