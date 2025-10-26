import '../models/membership_pass.dart';

class PassRepository {
  PassRepository() {
    _seed();
  }

  final List<MembershipPass> _passes = [];

  void _seed() {
    _passes.add(
      MembershipPass(
        id: 'pass_infinity',
        name: 'بطاقة Infinity Flex',
        description:
            'بطاقة عضوية فاخرة تسمح لك بالتدرب في 12 ناديًا مميزًا مع مدربين مختلفين كل أسبوع.',
        pricePerMonth: 899,
        perks: const [
          'حجز حصص زومبا كل ثلاثاء في Oasis Wellness',
          'أيروبيكس الخميس مع مدرب ضيف في Coral Active',
          'وصول غير محدود إلى جلسات الاستشفاء البارد',
          'خصم 20٪ على منتجات المتجر وصالون العناية',
          'دعوة مجانية لصديق كل شهر',
        ],
        includedClubs: const [
          'Oasis Wellness Club — الرياض',
          'Coral Active Hub — دبي',
          'Peak Performance Lab — الدوحة',
          'Skyline Flow Studio — أبوظبي',
          'Atlas Strength Forge — جدة',
        ],
        weeklySchedule: const {
          'الاثنين': ['جلسة HIIT — Peak Performance 6:30 م', 'جلسة استشفاء — Skyline Flow 8:00 م'],
          'الثلاثاء': ['زومبا — Oasis Wellness 7:30 م'],
          'الأربعاء': ['يوغا شروق — Coral Active 6:00 ص'],
          'الخميس': ['أيروبيكس — Coral Active 7:45 م', 'جلسة قوة — Atlas Strength 9:00 م'],
          'السبت': ['جولة دراجات — Skyline Flow 5:30 ص'],
        },
        expiration: DateTime.now().add(const Duration(days: 180)),
        image: 'https://images.unsplash.com/photo-1546484959-f9a53ce5f3f',
      ),
    );
  }

  Future<MembershipPass> fetchPrimaryPass() async {
    await Future.delayed(const Duration(milliseconds: 260));
    return _passes.first;
  }
}
