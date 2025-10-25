import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/feature_catalog.dart';
import '../../core/localization/app_localizations.dart';
import '../../screens/feature/feature_experience_screen.dart';
import '../animations/animated_reveal.dart';

class FeatureShowcase extends StatefulWidget {
  const FeatureShowcase({super.key, this.limit});

  final int? limit;

  @override
  State<FeatureShowcase> createState() => _FeatureShowcaseState();
}

class _FeatureShowcaseState extends State<FeatureShowcase> {
  late final PageController _controller;
  double _page = 0;

  List<FeatureDescriptor> get _features {
    if (widget.limit == null) return kProTradingFeatures;
    return kProTradingFeatures.take(widget.limit!).toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.78);
    _controller.addListener(_handleScroll);
  }

  void _handleScroll() {
    final value = _controller.page;
    if (value != null && value != _page) {
      setState(() => _page = value);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final features = _features;
    if (features.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _controller,
            itemCount: features.length,
            padEnds: features.length < 3,
            itemBuilder: (context, index) {
              final distance = (index - _page).abs();
              final scale = 1 - math.min(0.15, distance * 0.08);
              final opacity = 1 - math.min(0.6, distance * 0.25);
              return AnimatedReveal(
                delay: Duration(milliseconds: index * 40),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: _FeatureCard(
                      descriptor: features[index],
                      onTap: () => Navigator.of(context).pushNamed(
                        'feature.experience',
                        arguments: FeatureExperienceArgs(
                          index: index,
                          descriptor: features[index],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _DeckIndicator(
          length: features.length,
          controller: _controller,
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.descriptor, required this.onTap});

  final FeatureDescriptor descriptor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: colors.surface,
          border: Border.all(color: colors.outline.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 16),
              blurRadius: 32,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colors.primary.withOpacity(0.12),
              ),
              alignment: Alignment.center,
              child: FaIcon(descriptor.icon, color: colors.primary, size: 20),
            ),
            const SizedBox(height: 16),
            Text(
              descriptor.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                descriptor.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  strings.t('preview'),
                  style:
                      Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.swipe, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeckIndicator extends StatelessWidget {
  const _DeckIndicator({required this.length, required this.controller});

  final int length;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final page = controller.hasClients ? controller.page ?? 0 : controller.initialPage.toDouble();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(length, (index) {
            final selected = (page - index).abs() < 0.5;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: selected ? 18 : 6,
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        );
      },
    );
  }
}

