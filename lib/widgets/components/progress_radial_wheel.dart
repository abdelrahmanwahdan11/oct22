import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProgressRadialWheel extends StatelessWidget {
  const ProgressRadialWheel({
    super.key,
    required this.segments,
    required this.progress,
    required this.label,
  });

  final List<Map<String, dynamic>> segments;
  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(220),
            painter: _WheelPainter(segments: segments),
          ).animate().fadeIn(260.ms).scale(begin: 0.94, end: 1),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${(progress * 100).round()}%',
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter({required this.segments});

  final List<Map<String, dynamic>> segments;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2);
    final total = segments.fold<double>(0, (prev, element) => prev + (element['value'] as double));
    double startAngle = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    for (final segment in segments) {
      final value = (segment['value'] as double) / (total == 0 ? 1 : total);
      final sweep = value * 2 * math.pi;
      paint.color = (segment['color'] as Color);
      canvas.drawArc(rect.deflate(12), startAngle, sweep, false, paint);
      startAngle += sweep;
    }

    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.white.withOpacity(0.12);
    canvas.drawCircle(size.center(Offset.zero), size.width / 4, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
