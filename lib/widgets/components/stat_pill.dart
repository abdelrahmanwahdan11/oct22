import 'package:flutter/material.dart';

import '../../core/utils/animations.dart';

class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.label,
    required this.value,
    required this.trend,
  });

  final String label;
  final String value;
  final double trend;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF14171C) : const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 80,
            child: CustomPaint(
              painter: _TrendPainter(color: isDark ? Colors.tealAccent : Colors.teal),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).hintColor),
              ),
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                trend >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: trend >= 0 ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text('${trend.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    ).fadeMove();
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.2), color],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.6, size.width * 0.5,
          size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.9, size.width,
          size.height * 0.3)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
