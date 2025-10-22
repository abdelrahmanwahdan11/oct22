import 'package:smart_home_control/models/access_rule.dart';
import 'package:smart_home_control/models/device.dart';
import 'package:smart_home_control/models/energy_point.dart';
import 'package:smart_home_control/models/room.dart';

class MockData {
  static final rooms = <Room>[
    Room(
      id: 'r1',
      name: 'Living Room',
      photo: 'assets/images/room_living.jpg',
      devicesTotal: 12,
      devicesActive: 6,
      temperature: 28,
      favorite: true,
      devices: const ['d1', 'd2', 'd3', 'd4'],
    ),
    Room(
      id: 'r2',
      name: 'Kitchen Room',
      photo: 'assets/images/room_kitchen.jpg',
      devicesTotal: 8,
      devicesActive: 5,
      temperature: 23,
      favorite: false,
      devices: const ['d5', 'd6'],
    ),
    Room(
      id: 'r3',
      name: 'Drawing Room',
      photo: 'assets/images/room_living.jpg',
      devicesTotal: 8,
      devicesActive: 5,
      temperature: 18,
      favorite: false,
      devices: const ['d7', 'd8'],
    ),
  ];

  static final devices = <Device>[
    Device(
      id: 'd1',
      name: 'Panasonic AC',
      type: DeviceType.climate,
      roomId: 'r1',
      image: 'assets/images/device_ac.png',
      isOn: true,
      modes: const ['Cooling', 'Dry', 'Heating', 'Fan'],
      temperature: 24,
      targetTemp: 24,
      schedule: Schedule(
        id: 's1',
        deviceId: 'd1',
        enabled: true,
        start: '17:00',
        end: '18:20',
        repeat: const ['Mon', 'Tue', 'Wed', 'Thu'],
      ),
      activeMode: 'Cooling',
    ),
    Device(
      id: 'd2',
      name: 'Security Robo',
      type: DeviceType.robot,
      roomId: 'r1',
      image: 'assets/images/device_robot.png',
      isOn: true,
    ),
    Device(
      id: 'd3',
      name: 'CC Camera',
      type: DeviceType.camera,
      roomId: 'r1',
      image: 'assets/images/device_camera.png',
      isOn: true,
    ),
    Device(
      id: 'd4',
      name: 'Smart Light',
      type: DeviceType.light,
      roomId: 'r1',
      image: 'assets/images/device_lamp.png',
      isOn: true,
      schedule: Schedule(
        id: 's2',
        deviceId: 'd4',
        enabled: true,
        start: '19:00',
        end: '02:00',
        repeat: const ['Daily'],
      ),
      activeMode: 'Night',
    ),
    Device(
      id: 'd5',
      name: 'Speaker',
      type: DeviceType.speaker,
      roomId: 'r2',
      image: 'assets/images/device_speaker.png',
      isOn: false,
    ),
    Device(
      id: 'd6',
      name: 'Cleaner Robo',
      type: DeviceType.robot,
      roomId: 'r2',
      image: 'assets/images/device_cleaner.png',
      isOn: true,
    ),
  ];

  static final energy = <EnergyPoint>[
    EnergyPoint(month: 'Jul', kwh: 320),
    EnergyPoint(month: 'Aug', kwh: 369),
    EnergyPoint(month: 'Sep', kwh: 260),
    EnergyPoint(month: 'Oct', kwh: 270),
    EnergyPoint(month: 'Nov', kwh: 300),
    EnergyPoint(month: 'Dec', kwh: 313),
  ];

  static final accessRules = <AccessRule>[
    AccessRule(
      id: 'a1',
      title: 'Control Security Cameras',
      description: '2 Member Access',
      enabled: true,
      visibility: 'members',
    ),
    AccessRule(
      id: 'a2',
      title: 'Lock / Unlock Doors',
      description: 'All Members Access',
      enabled: true,
      visibility: 'members',
    ),
    AccessRule(
      id: 'a3',
      title: 'Energy Usage Reports',
      description: 'Only me',
      enabled: false,
      visibility: 'owner',
    ),
    AccessRule(
      id: 'a4',
      title: 'Lighting Control',
      description: 'All Members Access',
      enabled: true,
      visibility: 'members',
    ),
  ];
}
