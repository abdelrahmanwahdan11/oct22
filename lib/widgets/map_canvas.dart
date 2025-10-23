import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/design_system.dart';
import '../models/models.dart';

class MapCanvas extends StatelessWidget {
  const MapCanvas({
    super.key,
    required this.stops,
  });

  final List<Stop> stops;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.radiusXL.x),
        boxShadow: [AppShadows.card],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_base.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _RoutePainter(stops: stops),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  _RoutePainter({required this.stops});

  final List<Stop> stops;

  @override
  void paint(Canvas canvas, Size size) {
    if (stops.isEmpty) {
      return;
    }
    final pathPoints = <Offset>[];
    if (stops.length == 1) {
      pathPoints.add(Offset(size.width * 0.5, size.height * 0.5));
    } else {
      for (var i = 0; i < stops.length; i++) {
        final t = i / (stops.length - 1);
        final dx = lerpDouble(size.width * 0.1, size.width * 0.85, t)!;
        final dy = lerpDouble(size.height * 0.2, size.height * 0.75, t)!;
        pathPoints.add(Offset(dx, dy));
      }
    }

    final pathPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    if (pathPoints.length > 1) {
      final path = Path()..moveTo(pathPoints.first.dx, pathPoints.first.dy);
      for (var i = 1; i < pathPoints.length; i++) {
        path.lineTo(pathPoints[i].dx, pathPoints[i].dy);
      }
      canvas.drawPath(path, pathPaint);
    }

    final delayPaint = Paint()
      ..color = AppColors.danger
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    if (pathPoints.length > 2) {
      final start = pathPoints[pathPoints.length - 2];
      final end = pathPoints.last;
      canvas.drawLine(start, end, delayPaint);
    }

    final nodePaint = Paint()
      ..color = AppColors.limeDark
      ..style = PaintingStyle.fill;

    for (final point in pathPoints) {
      canvas.drawCircle(point, 9, nodePaint);
      canvas.drawCircle(point, 14, nodePaint..color = AppColors.limeSoft);
      nodePaint.color = AppColors.limeDark;
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) {
    return oldDelegate.stops != stops;
  }
}
