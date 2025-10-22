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
    String? name,
    DeviceType? type,
    String? roomId,
    String? image,
    bool? isOn,
    double? temperature,
    double? targetTemp,
    Schedule? schedule,
    String? activeMode,
    List<String>? modes,
  }) {
    return Device(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      roomId: roomId ?? this.roomId,
      image: image ?? this.image,
      isOn: isOn ?? this.isOn,
      modes: modes ?? this.modes,
      temperature: temperature ?? this.temperature,
      targetTemp: targetTemp ?? this.targetTemp,
      schedule: schedule ?? this.schedule,
      activeMode: activeMode ?? this.activeMode,
    );
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      type: _typeFromString(json['type'] as String?),
      roomId: json['roomId'] as String? ?? '',
      image: json['image'] as String? ?? '',
      isOn: json['isOn'] as bool? ?? false,
      modes: (json['modes'] as List<dynamic>? ?? []).cast<String>(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      targetTemp: (json['targetTemp'] as num?)?.toDouble(),
      schedule: json['schedule'] == null
          ? null
          : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
      activeMode: json['activeMode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'roomId': roomId,
      'image': image,
      'isOn': isOn,
      'modes': modes,
      'temperature': temperature,
      'targetTemp': targetTemp,
      'schedule': schedule?.toJson(),
      'activeMode': activeMode,
    };
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

DeviceType _typeFromString(String? value) {
  switch (value) {
    case 'climate':
      return DeviceType.climate;
    case 'camera':
      return DeviceType.camera;
    case 'light':
      return DeviceType.light;
    case 'robot':
      return DeviceType.robot;
    case 'speaker':
      return DeviceType.speaker;
    case 'cleaner':
      return DeviceType.cleaner;
    default:
      return DeviceType.other;
  }
}
