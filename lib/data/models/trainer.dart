import 'fitness_club.dart';

class TrainerProfile {
  TrainerProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.bio,
    required this.rating,
    required this.languages,
    required this.avatar,
    required this.sessionTypes,
    required this.contactEmail,
    required this.contactPhone,
    required this.social,
    required this.clubs,
    required this.nextAvailability,
  });

  final String id;
  final String name;
  final String specialty;
  final String bio;
  final double rating;
  final List<String> languages;
  final String avatar;
  final List<String> sessionTypes;
  final String contactEmail;
  final String contactPhone;
  final Map<String, String> social;
  final List<FitnessClub> clubs;
  final List<String> nextAvailability;
}

class TrainerApplication {
  TrainerApplication({
    required this.name,
    required this.specialty,
    required this.bio,
    required this.languages,
    required this.experienceYears,
    required this.certifications,
    required this.preferredClubs,
    required this.contactEmail,
    required this.contactPhone,
  });

  final String name;
  final String specialty;
  final String bio;
  final List<String> languages;
  final int experienceYears;
  final List<String> certifications;
  final List<String> preferredClubs;
  final String contactEmail;
  final String contactPhone;
}
