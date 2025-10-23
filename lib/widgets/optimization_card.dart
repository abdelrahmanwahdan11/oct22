import 'package:flutter/material.dart';

import '../core/design_system.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';

class OptimizationCard extends StatelessWidget {
  const OptimizationCard({
    super.key,
    required this.points,
    required this.moneyDelta,
    required this.milesDelta,
  });

  final List<ChartPoint> points;
  final int moneyDelta;
  final int milesDelta;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
        boxShadow: [AppShadows.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.t('optimization_plan'),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _OptimizationPainter(points: points),
              child: Container(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _DeltaChip(label: '+\$${moneyDelta.toString()}'),
              const SizedBox(width: 12),
              _DeltaChip(label: '+$milesDelta mi'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            strings.t('extra_orders'),
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _OptimizationPainter extends CustomPainter {
  _OptimizationPainter({required this.points});

  final List<ChartPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }
    final xValues = points.map((e) => e.x).toList();
    final yValues = points.map((e) => e.y).toList();
    final minX = xValues.reduce((value, element) => value < element ? value : element);
    final maxX = xValues.reduce((value, element) => value > element ? value : element);
    final minY = yValues.reduce((value, element) => value < element ? value : element);
    final maxY = yValues.reduce((value, element) => value > element ? value : element);

    Offset scalePoint(ChartPoint point) {
      final xRange = (maxX - minX).abs() < 0.001 ? 1 : maxX - minX;
      final yRange = (maxY - minY).abs() < 0.001 ? 1 : maxY - minY;
      final dx = (point.x - minX) / xRange;
      final dy = (point.y - minY) / yRange;
      return Offset(dx * size.width, size.height - dy * size.height);
    }

    final scaledPoints = points.map(scalePoint).toList();

    final areaPath = Path()..moveTo(scaledPoints.first.dx, size.height);
    for (final point in scaledPoints) {
      areaPath.lineTo(point.dx, point.dy);
    }
    areaPath.lineTo(scaledPoints.last.dx, size.height);
    areaPath.close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.limeSoft, Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(areaPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.limeDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final linePath = Path()..moveTo(scaledPoints.first.dx, scaledPoints.first.dy);
    for (var i = 1; i < scaledPoints.length; i++) {
      linePath.lineTo(scaledPoints[i].dx, scaledPoints[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()..color = AppColors.limeDark;
    for (final point in scaledPoints) {
      canvas.drawCircle(point, 6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OptimizationPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _DeltaChip extends StatelessWidget {
  const _DeltaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.limeSoft,
        borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
      ),
      child: Text(
        label,
        style: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
