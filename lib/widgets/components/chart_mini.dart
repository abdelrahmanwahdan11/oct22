import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ChartMini extends StatelessWidget {
  const ChartMini({super.key, required this.points, required this.isGain});

  final List<double> points;
  final bool isGain;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    return SizedBox(
      height: 48,
      child: CustomPaint(
        painter: _MiniChartPainter(
          points: points,
          color: isGain ? colors.profit : colors.loss,
        ),
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  _MiniChartPainter({required this.points, required this.color});

  final List<double> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final gradient = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.2), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final minPoint = points.reduce((a, b) => a < b ? a : b);
    final maxPoint = points.reduce((a, b) => a > b ? a : b);
    final range = (maxPoint - minPoint).abs() < 0.0001 ? 1 : maxPoint - minPoint;

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height - ((points[i] - minPoint) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, gradient);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MiniChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
