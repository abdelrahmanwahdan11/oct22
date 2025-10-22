import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double compact = 600;
  static const double medium = 1024;

  static bool isCompact(double width) => width < compact;
  static bool isMedium(double width) => width >= compact && width < medium;
  static bool isExpanded(double width) => width >= medium;

  static EdgeInsets geometry(double width) {
    if (isExpanded(width)) {
      return const EdgeInsets.symmetric(horizontal: 72, vertical: 32);
    }
    if (isMedium(width)) {
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 20);
  }

  static double cardWidth(double width) {
    if (isExpanded(width)) return 1040;
    if (isMedium(width)) return 840;
    return width;
  }

  static int columns(
    double width, {
    int compact = 2,
    int medium = 3,
    int expanded = 4,
  }) {
    if (isExpanded(width)) return expanded;
    if (isMedium(width)) return medium;
    return compact;
  }
}

class ResponsiveConstrainedBox extends StatelessWidget {
  const ResponsiveConstrainedBox({
    super.key,
    required this.builder,
    this.maxWidth = 1200,
    this.alignment = Alignment.topCenter,
  });

  final double maxWidth;
  final Alignment alignment;
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final contentWidth = width.clamp(0, maxWidth).toDouble();
        return Align(
          alignment: alignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: builder(context, constraints),
          ),
        );
      },
    );
  }
}

class AdaptiveSliverGridDelegate extends SliverGridDelegate {
  AdaptiveSliverGridDelegate({
    required this.minChildWidth,
    this.maxChildWidth = 320,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
    this.childAspectRatio = 1,
  });

  final double minChildWidth;
  final double maxChildWidth;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final width = constraints.crossAxisExtent;
    int count = width ~/ minChildWidth;
    if (count <= 0) {
      count = 1;
    }
    final maxCount = (width / maxChildWidth).floor();
    if (maxCount > 0 && count > maxCount) {
      count = maxCount;
    }
    final usable = width - (count - 1) * crossAxisSpacing;
    final childCrossExtent = usable / count;
    final childMainExtent = childCrossExtent / childAspectRatio;
    return SliverGridRegularTileLayout(
      crossAxisCount: count,
      mainAxisStride: childMainExtent + mainAxisSpacing,
      crossAxisStride: childCrossExtent + crossAxisSpacing,
      childMainAxisExtent: childMainExtent,
      childCrossAxisExtent: childCrossExtent,
      reverseCrossAxis: false,
    );
  }

  @override
  bool shouldRelayout(covariant AdaptiveSliverGridDelegate oldDelegate) {
    return oldDelegate.minChildWidth != minChildWidth ||
        oldDelegate.maxChildWidth != maxChildWidth ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.childAspectRatio != childAspectRatio;
  }
}
