import 'package:smart_home_control/models/device.dart';

class DeviceTemplate {
  const DeviceTemplate({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    this.modes = const [],
    this.temperature,
    this.targetTemp,
  });

  final String id;
  final String name;
  final DeviceType type;
  final String image;
  final List<String> modes;
  final double? temperature;
  final double? targetTemp;
}
