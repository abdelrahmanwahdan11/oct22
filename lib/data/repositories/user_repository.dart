import '../models/user.dart';

class UserRepository {
  UserRepository();

  final User _user = User(
    id: 'user-1',
    name: 'Lina Faris',
    avatar:
        'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=160&q=80',
    gender: 'female',
    dob: DateTime(1992, 6, 12),
    goals: ['energy', 'focus', 'resilience'],
    allergies: ['soy'],
    locale: 'ar',
  );

  User get currentUser => _user;
}
