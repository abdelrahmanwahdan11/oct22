import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ChartFull extends StatelessWidget {
  const ChartFull({
    super.key,
    required this.points,
    required this.isGain,
    this.labels = const ['1D', '1W', '1M', '3M', '1Y'],
  });

  final List<double> points;
  final bool isGain;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 220,
        child: CustomPaint(
          painter: _FullChartPainter(
            points: points,
            color: isGain ? colors.profit : colors.loss,
            gridColor: colors.border,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: labels.map((label) => Text(label, style: Theme.of(context).textTheme.caption)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FullChartPainter extends CustomPainter {
  _FullChartPainter({
    required this.points,
    required this.color,
    required this.gridColor,
  });

  final List<double> points;
  final Color color;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final minPoint = points.reduce((a, b) => a < b ? a : b);
    final maxPoint = points.reduce((a, b) => a > b ? a : b);
    final range = (maxPoint - minPoint).abs() < 0.0001 ? 1 : maxPoint - minPoint;

    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const horizontalDivisions = 4;
    for (var i = 0; i <= horizontalDivisions; i++) {
      final dy = size.height * i / horizontalDivisions;
      final path = Path()
        ..moveTo(0, dy)
        ..lineTo(size.width, dy);
      canvas.drawPath(path, gridPaint);
    }

    final path = Path();
    final pointsOffset = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height - ((points[i] - minPoint) / range) * size.height;
      pointsOffset.add(Offset(x, y));
    }

    path.moveTo(pointsOffset.first.dx, pointsOffset.first.dy);
    for (var i = 1; i < pointsOffset.length; i++) {
      final prev = pointsOffset[i - 1];
      final current = pointsOffset[i];
      final control1 = Offset((prev.dx + current.dx) / 2, prev.dy);
      final control2 = Offset((prev.dx + current.dx) / 2, current.dy);
      path.cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, current.dx, current.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(pointsOffset.last.dx, size.height)
      ..lineTo(pointsOffset.first.dx, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.25), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    for (final offset in pointsOffset) {
      canvas.drawCircle(offset, 3, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _FullChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
