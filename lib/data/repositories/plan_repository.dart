import '../models/plan_item.dart';

class PlanRepository {
  PlanRepository();

  final List<PlanItem> _planItems = [
    PlanItem(
      supplementId: 'sup-omega3',
      time: const PlanTime(hour: 8, minute: 0),
      dose: '2 softgels',
    ),
    PlanItem(
      supplementId: 'sup-bcomplex',
      time: const PlanTime(hour: 12, minute: 30),
      dose: '1 capsule',
    ),
    PlanItem(
      supplementId: 'sup-mag',
      time: const PlanTime(hour: 21, minute: 30),
      dose: '2 tablets',
    ),
  ];

  List<PlanItem> getTodayPlan() {
    return _planItems.map((item) => item.copyWith(status: item.status)).toList();
  }

  void updateStatus(String supplementId, PlanStatus status) {
    final index =
        _planItems.indexWhere((element) => element.supplementId == supplementId);
    if (index != -1) {
      _planItems[index].status = status;
    }
  }
}
