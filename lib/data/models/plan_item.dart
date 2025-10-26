enum PlanStatus { pending, taken, skipped }

class PlanItem {
  PlanItem({
    required this.supplementId,
    required this.time,
    required this.dose,
    this.status = PlanStatus.pending,
  });

  final String supplementId;
  final PlanTime time;
  final String dose;
  PlanStatus status;

  PlanItem copyWith({PlanStatus? status}) {
    return PlanItem(
      supplementId: supplementId,
      time: time,
      dose: dose,
      status: status ?? this.status,
    );
  }
}

class PlanTime {
  const PlanTime({required this.hour, required this.minute});

  final int hour;
  final int minute;

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
