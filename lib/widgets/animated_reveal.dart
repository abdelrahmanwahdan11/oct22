import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class AnimatedReveal extends StatefulWidget {
  const AnimatedReveal({
    super.key,
    required this.child,
    this.delayFactor = 0,
    this.duration,
    this.curve,
    this.enableScale = true,
  });

  final int delayFactor;
  final Duration? duration;
  final Curve? curve;
  final bool enableScale;
  final Widget child;

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    final duration = widget.duration ?? AppMotion.base;
    _controller = AnimationController(vsync: this, duration: duration);
    final curve = CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? AppMotion.curve,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(curve);
    _offset = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(curve);
    _scale = Tween<double>(begin: 0.98, end: 1).animate(curve);
    _scheduleStart();
  }

  void _scheduleStart() {
    if (!mounted) return;
    final delay = widget.delayFactor <= 0
        ? Duration.zero
        : Duration(milliseconds: math.min(9, widget.delayFactor) * 70);
    Future<void>.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _controller.reset();
      _scheduleStart();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.enableScale
            ? ScaleTransition(scale: _scale, child: widget.child)
            : widget.child,
      ),
    );
  }
}
