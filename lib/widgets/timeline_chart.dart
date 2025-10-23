import 'package:flutter/material.dart';

import '../core/design_system.dart';
import '../models/models.dart';

class TimelineChart extends StatelessWidget {
  const TimelineChart({
    super.key,
    required this.points,
    this.showLegend = true,
  });

  final List<SchedulePoint> points;
  final bool showLegend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusLG.x),
        boxShadow: [AppShadows.soft],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _TimelinePainter(points: points),
              child: Container(),
            ),
          ),
          if (showLegend) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: points
                  .map(
                    (point) => _LegendChip(
                      color: point.color,
                      label: '${point.time} • ${point.label}',
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({required this.points});

  final List<SchedulePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }
    final paint = Paint()
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final baseY = size.height / 2;
    final segmentWidth = size.width / points.length;

    double startX = 0;
    for (final point in points) {
      paint.color = point.color;
      final endX = startX + segmentWidth;
      final path = Path()
        ..moveTo(startX, baseY)
        ..lineTo(endX, baseY);
      canvas.drawPath(path, paint);

      final markerPaint = Paint()
        ..color = point.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(endX, baseY), 8, markerPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: point.time,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(maxWidth: 120);
      textPainter.paint(canvas, Offset(endX - textPainter.width / 2, baseY + 14));

      startX = endX;
    }
  }

  @override
  bool shouldRepaint(covariant _TimelinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadii.radiusChip.x),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
