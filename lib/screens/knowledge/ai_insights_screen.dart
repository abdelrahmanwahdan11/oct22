import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/feature_catalog.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/components/feature_showcase.dart';
import '../../widgets/animations/animated_reveal.dart';

class AiInsightsScreen extends StatelessWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final colors = TradeXTheme.colorsOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('ai_insights')),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('search'),
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlassChart),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth >= 1100
              ? 1000.0
              : constraints.maxWidth >= 840
                  ? 860.0
                  : constraints.maxWidth;
          final horizontal = constraints.maxWidth > maxWidth
              ? (constraints.maxWidth - maxWidth) / 2
              : 16.0;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedReveal(
                        child: Text(
                          strings.t('ai_briefing_headline'),
                          style: theme.textTheme.displaySmall,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedReveal(
                        child: Text(
                          strings.t('ai_briefing_intro'),
                          style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _InsightSection(
                        title: strings.t('ai_focus_market'),
                        icon: FontAwesomeIcons.chartColumn,
                        bulletColor: colors.accent,
                        items: [
                          strings.t('ai_focus_market_item1'),
                          strings.t('ai_focus_market_item2'),
                          strings.t('ai_focus_market_item3'),
                          strings.t('ai_focus_market_item4'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _InsightSection(
                        title: strings.t('ai_focus_risk'),
                        icon: FontAwesomeIcons.shieldHalved,
                        bulletColor: colors.loss,
                        items: [
                          strings.t('ai_focus_risk_item1'),
                          strings.t('ai_focus_risk_item2'),
                          strings.t('ai_focus_risk_item3'),
                          strings.t('ai_focus_risk_item4'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _InsightSection(
                        title: strings.t('ai_focus_learning'),
                        icon: FontAwesomeIcons.bookOpen,
                        bulletColor: colors.muted,
                        items: [
                          strings.t('ai_focus_learning_item1'),
                          strings.t('ai_focus_learning_item2'),
                          strings.t('ai_focus_learning_item3'),
                          strings.t('ai_focus_learning_item4'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        strings.t('ai_feature_catalog'),
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),
                      const FeatureShowcase(),
                      const SizedBox(height: 48),
                      Text(
                        strings.t('ai_next_steps'),
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      _NextStepsGrid(strings: strings, theme: theme, colors: colors),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InsightSection extends StatelessWidget {
  const _InsightSection({
    required this.title,
    required this.icon,
    required this.bulletColor,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color bulletColor;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(icon, size: 18),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: bulletColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NextStepsGrid extends StatelessWidget {
  const _NextStepsGrid({
    required this.strings,
    required this.theme,
    required this.colors,
  });

  final AppLocalizations strings;
  final ThemeData theme;
  final TradeXColors colors;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _NextStepCard(
              icon: FontAwesomeIcons.playCircle,
              title: strings.t('ai_next_step_simulator'),
              subtitle: strings.t('ai_next_step_simulator_desc'),
              theme: theme,
              colors: colors,
            ),
            _NextStepCard(
              icon: FontAwesomeIcons.personChalkboard,
              title: strings.t('ai_next_step_lessons'),
              subtitle: strings.t('ai_next_step_lessons_desc'),
              theme: theme,
              colors: colors,
            ),
            _NextStepCard(
              icon: FontAwesomeIcons.diagramProject,
              title: strings.t('ai_next_step_strategy'),
              subtitle: strings.t('ai_next_step_strategy_desc'),
              theme: theme,
              colors: colors,
            ),
            if (isWide)
              _NextStepCard(
                icon: FontAwesomeIcons.headset,
                title: strings.t('ai_next_step_support'),
                subtitle: strings.t('ai_next_step_support_desc'),
                theme: theme,
                colors: colors,
              ),
          ],
        );
      },
    );
  }
}

class _NextStepCard extends StatelessWidget {
  const _NextStepCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.theme,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeData theme;
  final TradeXColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.colorScheme.surface,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, size: 22),
          const SizedBox(height: 14),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}
