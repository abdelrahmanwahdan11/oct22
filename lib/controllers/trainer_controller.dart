import 'package:flutter/foundation.dart';

import '../data/models/fitness_club.dart';
import '../data/models/trainer.dart';
import '../data/repositories/trainer_repository.dart';

class TrainerController extends ChangeNotifier {
  TrainerController(this._repository);

  final TrainerRepository _repository;

  List<TrainerProfile> _trainers = const [];
  List<FitnessClub> _clubs = const [];
  bool _isLoading = false;
  bool _isSubmitting = false;

  List<TrainerProfile> get trainers => _trainers;
  List<FitnessClub> get clubs => _clubs;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    _clubs = await _repository.fetchClubs();
    _trainers = await _repository.fetchTrainers();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _trainers = await _repository.fetchTrainers(delay: Duration.zero);
    notifyListeners();
  }

  Future<void> submitApplication(TrainerApplication application) async {
    _isSubmitting = true;
    notifyListeners();
    await _repository.submitApplication(application);
    _isSubmitting = false;
    await refresh();
  }
}
