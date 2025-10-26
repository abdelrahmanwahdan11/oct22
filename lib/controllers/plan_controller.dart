import 'package:flutter/material.dart';

import '../data/models/plan_item.dart';
import '../data/repositories/plan_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/supplements_repository.dart';

class PlanController extends ChangeNotifier {
  PlanController(
    this._planRepository,
    this._progressRepository,
    this._supplementsRepository,
  );

  final PlanRepository _planRepository;
  final ProgressRepository _progressRepository;
  final SupplementsRepository _supplementsRepository;

  List<PlanItem> _planItems = [];

  List<PlanItem> get planItems => List.unmodifiable(_planItems);

  Future<void> load() async {
    _planItems = _planRepository.getTodayPlan();
    notifyListeners();
  }

  Future<void> markStatus(String supplementId, PlanStatus status) async {
    _planRepository.updateStatus(supplementId, status);
    await load();
  }

  double get completionRate {
    if (_planItems.isEmpty) return 0;
    final taken =
        _planItems.where((item) => item.status == PlanStatus.taken).length;
    return taken / _planItems.length;
  }

  List<Map<String, dynamic>> get progressSegments {
    final segments = _progressRepository.buildSegments(_planItems);
    return segments
        .map(
          (segment) => {
            'label': segment.label,
            'value': segment.value,
            'color': segment.color,
          },
        )
        .toList();
  }

  String supplementName(String id) {
    return _supplementsRepository.getById(id)?.name ?? id;
  }
}
