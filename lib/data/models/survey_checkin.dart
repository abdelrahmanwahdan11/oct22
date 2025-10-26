class SurveyCheckin {
  const SurveyCheckin({
    required this.id,
    required this.date,
    required this.moodScore,
    required this.energyScore,
    required this.notes,
  });

  final String id;
  final DateTime date;
  final int moodScore;
  final int energyScore;
  final String notes;
}
