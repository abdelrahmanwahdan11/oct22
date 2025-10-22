class Schedule {
  const Schedule({
    required this.id,
    required this.deviceId,
    required this.enabled,
    required this.start,
    required this.end,
    required this.repeat,
  });

  final String id;
  final String deviceId;
  final bool enabled;
  final String start;
  final String end;
  final List<String> repeat;

  Schedule copyWith({
    bool? enabled,
    String? start,
    String? end,
    List<String>? repeat,
  }) {
    return Schedule(
      id: id,
      deviceId: deviceId,
      enabled: enabled ?? this.enabled,
      start: start ?? this.start,
      end: end ?? this.end,
      repeat: repeat ?? this.repeat,
    );
  }
}
