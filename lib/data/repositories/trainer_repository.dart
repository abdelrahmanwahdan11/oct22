import 'dart:math';

import '../models/fitness_club.dart';
import '../models/trainer.dart';

class TrainerRepository {
  TrainerRepository() {
    _seedData();
  }

  final List<TrainerProfile> _trainers = [];
  final List<FitnessClub> _clubs = [];

  void _seedData() {
    final clubData = [
      (
        'club_oasis',
        'Oasis Wellness Club',
        'King Abdullah Rd, Exit 8',
        'Riyadh',
        '+966-555-1111',
        'خصم 25٪ على الحزم الجماعية',
        'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b',
        [
          'حمام سباحة شبه أولمبي',
          'حصص HIIT يومية',
          'سبا ومساج رياضي',
        ],
        'https://maps.google.com/?q=Riyadh+Fitness+Club',
      ),
      (
        'club_coral',
        'Coral Active Hub',
        'Jumeirah Beach Rd, 12',
        'Dubai',
        '+971-50-333-1212',
        'خصم 15٪ عند الحجز عبر التطبيق',
        'https://images.unsplash.com/photo-1546484959-f9a53ce5f9cb',
        [
          'استوديو يوجا مع إطلالة على البحر',
          'حصص زومبا مسائية',
          'تدريب تنفس وتأمل',
        ],
        'https://maps.google.com/?q=Dubai+Coral+Active',
      ),
      (
        'club_peak',
        'Peak Performance Lab',
        'Corniche St, Building 4',
        'Doha',
        '+974-555-9119',
        'اشتراك عائلي بخاصية الإهداء',
        'https://images.unsplash.com/photo-1556817411-31ae72fa3ea0',
        [
          'مختبر فحوصات أداء',
          'أجهزة تدريب متطورة',
          'مسار جري داخلي',
        ],
        'https://maps.google.com/?q=Doha+Peak+Performance',
      ),
    ];

    _clubs.addAll(clubData.map(
      (club) => FitnessClub(
        id: club.$1,
        name: club.$2,
        address: club.$3,
        city: club.$4,
        contactNumber: club.$5,
        discount: club.$6,
        image: club.$7,
        features: club.$8,
        mapUrl: club.$9,
      ),
    ));

    final rnd = Random(23);
    _trainers.addAll([
      TrainerProfile(
        id: 'trainer_nora',
        name: 'Nora Al-Harthy',
        specialty: 'تدريب قوة للسيدات',
        bio:
            'مدربة معتمدة بخبرة 8 سنوات في تصميم برامج القوة للسيدات مع تركيز على نمط الحياة المتوازن.',
        rating: 4.9,
        languages: const ['العربية', 'English'],
        avatar: 'https://images.unsplash.com/photo-1581009137042-c552e485697a',
        sessionTypes: const ['جلسات فردية', 'حصص صغيرة', 'استشارات تغذية'],
        contactEmail: 'nora@luma.fit',
        contactPhone: '+966-55-321-9988',
        social: const {
          'instagram': '@coach.nora',
          'whatsapp': 'https://wa.me/966553219988',
        },
        clubs: _clubs.sublist(0, 2),
        nextAvailability: List.generate(
          4,
          (index) => 'الثلاثاء ${index + 1}:00 مساءً — حصة HIIT',
        ),
      ),
      TrainerProfile(
        id: 'trainer_luis',
        name: 'Luis Fernandez',
        specialty: 'كروس فيت وHIIT',
        bio: 'مؤسس برنامج التحمل العالي مع خبرة في تدريب الفرق الرياضية.',
        rating: 4.7,
        languages: const ['English', 'Español'],
        avatar: 'https://images.unsplash.com/photo-1534367610401-9f5ed68180aa',
        sessionTypes: const ['CrossFit', 'HIIT', 'جلسات افتراضية'],
        contactEmail: 'luis@luma.fit',
        contactPhone: '+971-50-778-2010',
        social: const {
          'instagram': '@coachluis',
        },
        clubs: _clubs.sublist(0, 2),
        nextAvailability: List.generate(
          4,
          (index) => 'الأربعاء ${index + 6}:30 صباحاً — تمرين قوة',
        ),
      ),
      TrainerProfile(
        id: 'trainer_amira',
        name: 'Amira Bennani',
        specialty: 'يوجا وماندفلنس',
        bio:
            'مدربة يوغا وعافية ذهنية تعزز الترابط بين العقل والجسم عبر الجلسات التنفسية.',
        rating: 5.0,
        languages: const ['العربية', 'Français', 'English'],
        avatar: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b',
        sessionTypes: const ['يوجا فينياسا', 'جلسات صوتية', 'جلسات أونلاين'],
        contactEmail: 'amira@luma.fit',
        contactPhone: '+974-55-602-1122',
        social: const {
          'instagram': '@amira.flow',
          'linkedin': 'https://linkedin.com/in/amira-flow',
        },
        clubs: _clubs.sublist(1, 3),
        nextAvailability: List.generate(
          4,
          (index) => 'السبت ${index + 4}:00 مساءً — جلسة يوغا شمس الغروب',
        ),
      ),
    ]);

    // Add a few procedural trainers for variety.
    for (var i = 0; i < 6; i++) {
      final club = _clubs[i % _clubs.length];
      _trainers.add(
        TrainerProfile(
          id: 'trainer_auto_$i',
          name: 'Coach ${['Layla', 'Hassan', 'Maya', 'Adam', 'Farah', 'Sam'][i]}',
          specialty: ['سباحة', 'تغذية رياضية', 'بيلاتس', 'تايبو', 'جري', 'تأهيل'][i],
          bio:
              'جلسات متخصصة في ${['تحسين الأداء المائي', 'تقوية الحمية اليومية', 'مرونة الجسم', 'القوة الذهنية', 'السرعة والتحمل', 'العودة بعد الإصابات'][i]}.',
          rating: 4.5 + rnd.nextDouble() * 0.4,
          languages: const ['العربية', 'English'],
          avatar: 'https://images.unsplash.com/photo-1558611848-73f7eb4001a1?auto=format',
          sessionTypes: const ['جلسات فردية', 'مجموعات صغيرة'],
          contactEmail: 'coach${i + 1}@luma.fit',
          contactPhone: '+966-55-55${i}210',
          social: const {},
          clubs: [club],
          nextAvailability: [
            'الجمعة 7:00 مساءً — جلسة مخصصة',
            'الأحد 5:00 مساءً — حصة مجتمع',
          ],
        ),
      );
    }
  }

  Future<List<TrainerProfile>> fetchTrainers({Duration delay = const Duration(milliseconds: 380)}) async {
    await Future.delayed(delay);
    return List.unmodifiable(_trainers);
  }

  Future<List<FitnessClub>> fetchClubs() async {
    await Future.delayed(const Duration(milliseconds: 320));
    return List.unmodifiable(_clubs);
  }

  Future<void> submitApplication(TrainerApplication application) async {
    await Future.delayed(const Duration(milliseconds: 420));
    _trainers.add(
      TrainerProfile(
        id: 'trainer_${application.name.toLowerCase().replaceAll(' ', '_')}_${_trainers.length}',
        name: application.name,
        specialty: application.specialty,
        bio: application.bio,
        rating: 4.6,
        languages: application.languages,
        avatar: 'https://images.unsplash.com/photo-1558611848-73f7eb4001a1?auto=format',
        sessionTypes: const ['جلسات فردية', 'استشارات افتراضية'],
        contactEmail: application.contactEmail,
        contactPhone: application.contactPhone,
        social: const {},
        clubs: _clubs.where((club) => application.preferredClubs.contains(club.name)).toList(),
        nextAvailability: const ['سيتم التنسيق بعد الموافقة'],
      ),
    );
  }
}
