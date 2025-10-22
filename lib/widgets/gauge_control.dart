import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class GaugeControl extends StatelessWidget {
  const GaugeControl({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, 280.0);
        return SizedBox(
          width: size,
          height: size,
          child: _GaugePainterWidget(
            min: min,
            max: max,
            value: value,
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}

class _GaugePainterWidget extends StatefulWidget {
  const _GaugePainterWidget({
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<_GaugePainterWidget> createState() => _GaugePainterWidgetState();
}

class _GaugePainterWidgetState extends State<_GaugePainterWidget> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant _GaugePainterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => _handlePan(details.localPosition, context),
      onPanStart: (details) => _handlePan(details.localPosition, context),
      child: CustomPaint(
        painter: _GaugePainter(
          min: widget.min,
          max: widget.max,
          value: _value,
          theme: Theme.of(context),
        ),
      ),
    );
  }

  void _handlePan(Offset position, BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final center = size.center(Offset.zero);
    final vector = position - center;
    final angle = math.atan2(vector.dy, vector.dx);
    const startAngle = math.pi * 1.2;
    const sweepAngle = math.pi * 1.6;
    var normalized = angle - startAngle;
    while (normalized < 0) normalized += 2 * math.pi;
    normalized = normalized.clamp(0, sweepAngle);
    final ratio = normalized / sweepAngle;
    final newValue = widget.min + (widget.max - widget.min) * ratio;
    setState(() => _value = newValue);
    widget.onChanged(newValue);
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.min,
    required this.max,
    required this.value,
    required this.theme,
  });

  final double min;
  final double max;
  final double value;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 16;
    const startAngle = math.pi * 1.2;
    const sweepAngle = math.pi * 1.6;

    final basePaint = Paint()
      ..color = AppColors.border
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      basePaint,
    );

    final progressPaint = Paint()
      ..shader = const LinearGradient(colors: AppGradients.blueCapsule).createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;

    final ratio = ((value - min) / (max - min)).clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * ratio,
      false,
      progressPaint,
    );

    final tickPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 2;

    const tickCount = 8;
    for (var i = 0; i <= tickCount; i++) {
      final tickAngle = startAngle + (sweepAngle / tickCount) * i;
      final start = Offset(
        center.dx + (radius - 8) * math.cos(tickAngle),
        center.dy + (radius - 8) * math.sin(tickAngle),
      );
      final end = Offset(
        center.dx + (radius + 8) * math.cos(tickAngle),
        center.dy + (radius + 8) * math.sin(tickAngle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    final knobAngle = startAngle + sweepAngle * ratio;
    final knobCenter = Offset(
      center.dx + radius * math.cos(knobAngle),
      center.dy + radius * math.sin(knobAngle),
    );

    final knobPaint = Paint()..color = AppColors.blueDark;
    canvas.drawCircle(knobCenter, 12, knobPaint);
    canvas.drawCircle(knobCenter, 6, Paint()..color = Colors.white);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${value.toStringAsFixed(0)}°C',
        style: theme.textTheme.displayLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    final subtitlePainter = TextPainter(
      text: TextSpan(
        text: 'Target Temperature',
        style: theme.textTheme.bodyMedium,
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout();
    subtitlePainter.paint(
      canvas,
      center + Offset(-subtitlePainter.width / 2, textPainter.height / 2 + 8),
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
