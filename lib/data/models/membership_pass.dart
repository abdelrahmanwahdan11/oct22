class MembershipPass {
  const MembershipPass({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerMonth,
    required this.perks,
    required this.includedClubs,
    required this.weeklySchedule,
    required this.expiration,
    required this.image,
  });

  final String id;
  final String name;
  final String description;
  final double pricePerMonth;
  final List<String> perks;
  final List<String> includedClubs;
  final Map<String, List<String>> weeklySchedule;
  final DateTime expiration;
  final String image;
}
