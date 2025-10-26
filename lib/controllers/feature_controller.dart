import 'package:flutter/foundation.dart';

import '../data/models/feature_idea.dart';
import '../data/repositories/feature_repository.dart';

class FeatureController extends ChangeNotifier {
  FeatureController(this._repository);

  final FeatureRepository _repository;

  List<FeatureIdea> _ideas = const [];
  bool _isLoading = false;

  List<FeatureIdea> get ideas => _ideas;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    _ideas = await _repository.fetchIdeas();
    _isLoading = false;
    notifyListeners();
  }
}
