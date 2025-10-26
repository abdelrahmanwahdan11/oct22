import 'package:flutter/material.dart';

import '../models/plan_item.dart';
import '../models/progress_segment.dart';

class ProgressRepository {
  List<ProgressSegment> buildSegments(List<PlanItem> items) {
    final total = items.length.toDouble().clamp(1, double.infinity);
    final taken =
        items.where((item) => item.status == PlanStatus.taken).length / total;
    final pending =
        items.where((item) => item.status == PlanStatus.pending).length / total;
    final skipped =
        items.where((item) => item.status == PlanStatus.skipped).length / total;

    return [
      ProgressSegment(
        label: 'Taken',
        value: taken,
        color: const Color(0xFF49D2B1),
      ),
      ProgressSegment(
        label: 'Pending',
        value: pending,
        color: const Color(0xFFA1DD70),
      ),
      ProgressSegment(
        label: 'Skipped',
        value: skipped,
        color: const Color(0xFFF59E0B),
      ),
    ];
  }
}
