class Room {
  const Room({
    required this.id,
    required this.name,
    required this.photo,
    required this.devicesTotal,
    required this.devicesActive,
    required this.temperature,
    required this.favorite,
    required this.devices,
  });

  final String id;
  final String name;
  final String photo;
  final int devicesTotal;
  final int devicesActive;
  final int temperature;
  final bool favorite;
  final List<String> devices;

  Room copyWith({
    int? devicesActive,
    bool? favorite,
    List<String>? devices,
  }) {
    return Room(
      id: id,
      name: name,
      photo: photo,
      devicesTotal: devicesTotal,
      devicesActive: devicesActive ?? this.devicesActive,
      temperature: temperature,
      favorite: favorite ?? this.favorite,
      devices: devices ?? this.devices,
    );
  }
}
