class Booking {
  const Booking({
    required this.id,
    required this.propertyId,
    required this.date,
    required this.time,
    required this.name,
    required this.phone,
    this.note,
  });

  final String id;
  final String propertyId;
  final DateTime date;
  final String time;
  final String name;
  final String phone;
  final String? note;

  Booking copyWith({
    String? id,
    String? propertyId,
    DateTime? date,
    String? time,
    String? name,
    String? phone,
    String? note,
  }) {
    return Booking(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      date: date ?? this.date,
      time: time ?? this.time,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      note: note ?? this.note,
    );
  }
}
