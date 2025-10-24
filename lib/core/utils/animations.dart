import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension AppAnimations on Widget {
  Widget fadeMove({int delay = 0}) {
    return animate(delay: delay.ms)
        .fadeIn(duration: 300.ms, curve: Curves.easeOut)
        .moveY(begin: 12, end: 0, curve: Curves.easeOut);
  }

  Widget listItem({int index = 0}) {
    return animate(delay: (index * 60).ms)
        .fadeIn()
        .scale(begin: 0.98, end: 1);
  }
}

extension DurationExtensions on num {
  Duration get ms => Duration(milliseconds: (this * 1).round());
}
