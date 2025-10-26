class User {
  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.gender,
    required this.dob,
    required this.goals,
    required this.allergies,
    required this.locale,
  });

  final String id;
  final String name;
  final String avatar;
  final String gender;
  final DateTime dob;
  final List<String> goals;
  final List<String> allergies;
  final String locale;

  User copyWith({
    String? locale,
  }) {
    return User(
      id: id,
      name: name,
      avatar: avatar,
      gender: gender,
      dob: dob,
      goals: goals,
      allergies: allergies,
      locale: locale ?? this.locale,
    );
  }
}
