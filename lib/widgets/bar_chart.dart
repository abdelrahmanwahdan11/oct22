import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';
import 'package:smart_home_control/models/energy_point.dart';

class EnergyBarChart extends StatelessWidget {
  const EnergyBarChart({
    super.key,
    required this.points,
    required this.highlight,
    required this.onSelect,
  });

  final List<EnergyPoint> points;
  final String highlight;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: GestureDetector(
        onTapUp: (details) {
          final box = context.findRenderObject() as RenderBox?;
          if (box == null) return;
          final local = box.globalToLocal(details.globalPosition);
          final index = (local.dx ~/ (box.size.width / points.length))
              .clamp(0, points.length - 1);
          onSelect(points[index].month);
        },
        child: CustomPaint(
          painter: _BarChartPainter(points, highlight, Theme.of(context)),
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter(this.points, this.highlight, this.theme);

  final List<EnergyPoint> points;
  final String highlight;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final maxKwh = points.map((p) => p.kwh).fold<int>(0, (a, b) => b > a ? b : a);
    final barWidth = size.width / (points.length * 1.5);
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = (i + 0.5) * (size.width / points.length);
      final barHeight = (point.kwh / maxKwh) * (size.height - 40);
      final rect = Rect.fromLTWH(
        x - barWidth / 2,
        size.height - barHeight - 24,
        barWidth,
        barHeight,
      );
      final isHighlight = point.month == highlight;
      paint.color = isHighlight ? AppColors.blueDark : AppColors.blueSoft;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        paint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: point.month,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isHighlight ? AppColors.blueDark : AppColors.textSecondary,
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - textPainter.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.highlight != highlight;
  }
}
