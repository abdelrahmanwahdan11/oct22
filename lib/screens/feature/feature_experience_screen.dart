import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/feature_catalog.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/animations/animated_reveal.dart';
import '../../widgets/components/chart_mini.dart';

class FeatureExperienceArgs {
  const FeatureExperienceArgs({required this.index, required this.descriptor});

  final int index;
  final FeatureDescriptor descriptor;
}

class FeatureExperienceScreen extends StatefulWidget {
  const FeatureExperienceScreen({super.key, required this.args});

  final FeatureExperienceArgs args;

  @override
  State<FeatureExperienceScreen> createState() => _FeatureExperienceScreenState();
}

class _FeatureExperienceScreenState extends State<FeatureExperienceScreen> {
  final ValueNotifier<int> _timeframeIndex = ValueNotifier<int>(0);
  bool _autoPilot = true;
  bool _alertsEnabled = true;
  bool _whatIfMode = false;
  double _sensitivity = 0.6;

  late final List<List<double>> _series;

  @override
  void initState() {
    super.initState();
    _series = List.generate(4, (offset) => _generateSeries(widget.args.index + offset));
  }

  @override
  void dispose() {
    _timeframeIndex.dispose();
    super.dispose();
  }

  List<double> _generateSeries(int seed) {
    final random = Random(seed);
    final base = 100 + random.nextDouble() * 20;
    final points = <double>[];
    var value = base;
    for (var i = 0; i < 36; i++) {
      final swing = (random.nextDouble() - 0.5) * base * 0.015;
      value = max(2, value + swing);
      points.add(value);
    }
    return points;
  }

  List<Map<String, dynamic>> _metricBlueprint() {
    final titles = [
      'Momentum score',
      'Volatility delta',
      'Correlation drift',
      'Liquidity pulse',
      'Order flow skew',
      'Sentiment bias',
    ];
    final random = Random(widget.args.index);
    return titles
        .map(
          (title) => {
            'title': title,
            'value': (random.nextDouble() * 100).clamp(8, 98).toStringAsFixed(1),
            'unit': '%',
          },
        )
        .toList();
  }

  void _runSimulation() {
    final snack = SnackBar(
      content: Text('${widget.args.descriptor.title} • simulation scheduled for ${_timeframeLabel} horizon'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  String get _timeframeLabel {
    const labels = ['1D', '1W', '1M', '6M'];
    return labels[_timeframeIndex.value];
  }

  @override
  Widget build(BuildContext context) {
    final descriptor = widget.args.descriptor;
    final colors = TradeXTheme.colorsOf(context);
    final theme = Theme.of(context);
    final metrics = _metricBlueprint();
    return Scaffold(
      appBar: AppBar(
        title: Text(descriptor.title),
        actions: [
          IconButton(
            tooltip: 'Try in market compare',
            icon: const FaIcon(FontAwesomeIcons.scaleBalanced),
            onPressed: () => Navigator.of(context).pushNamed('asset.compare'),
          ),
          IconButton(
            tooltip: 'Bookmark capability',
            icon: Icon(_autoPilot ? Icons.bookmark_added : Icons.bookmark_add_outlined),
            onPressed: () => setState(() => _autoPilot = !_autoPilot),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth >= 1100
              ? 960.0
              : constraints.maxWidth >= 840
                  ? 820.0
                  : constraints.maxWidth;
          final horizontal = constraints.maxWidth > maxWidth ? (constraints.maxWidth - maxWidth) / 2 : 16.0;
          return ListView(
            padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 32),
            children: [
              AnimatedReveal(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(descriptor.subtitle, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
                      const SizedBox(height: 16),
                      ValueListenableBuilder<int>(
                        valueListenable: _timeframeIndex,
                        builder: (context, value, _) {
                          return SegmentedButton<int>(
                            segments: const [
                              ButtonSegment(value: 0, label: Text('1D')),
                              ButtonSegment(value: 1, label: Text('1W')),
                              ButtonSegment(value: 2, label: Text('1M')),
                              ButtonSegment(value: 3, label: Text('6M')),
                            ],
                            selected: {value},
                            onSelectionChanged: (selection) => _timeframeIndex.value = selection.first,
                            showSelectedIcon: false,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<int>(
                        valueListenable: _timeframeIndex,
                        builder: (context, value, _) {
                          final base = _series[value % _series.length];
                          final overlay = _series[(value + 1) % _series.length];
                          final overlayGain = overlay.last >= overlay.first;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Projected signal blend',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colors.surfaceSoft,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: colors.border),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: ChartMini(points: base, isGain: base.last >= base.first)),
                                        const SizedBox(width: 12),
                                        Expanded(child: ChartMini(points: overlay, isGain: overlayGain)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _SignalChip(
                                            icon: FontAwesomeIcons.gaugeHigh,
                                            label: 'Intensity',
                                            value: '${(base.last - base.first).abs().clamp(3, 28).toStringAsFixed(1)}%',
                                            color: colors.accent,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _SignalChip(
                                            icon: FontAwesomeIcons.wandMagicSparkles,
                                            label: 'AI confidence',
                                            value: '${(overlayGain ? 78 : 64) + value * 4}%',
                                            color: overlayGain ? colors.profit : colors.loss,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedReveal(
                delay: const Duration(milliseconds: 80),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tunable controls', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _autoPilot,
                        onChanged: (value) => setState(() => _autoPilot = value),
                        title: const Text('Auto-pilot execution'),
                        subtitle: const Text('Allow the engine to stage laddered orders automatically'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _alertsEnabled,
                        onChanged: (value) => setState(() => _alertsEnabled = value),
                        title: const Text('Smart alerts'),
                        subtitle: const Text('Deliver push alerts when scores breach guardrails'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _whatIfMode,
                        onChanged: (value) => setState(() => _whatIfMode = value),
                        title: const Text('What-if sandbox'),
                        subtitle: const Text('Inject macro shocks to preview stress outcomes'),
                      ),
                      const SizedBox(height: 12),
                      Text('Signal sensitivity (${(_sensitivity * 100).round()}%)', style: theme.textTheme.bodyMedium),
                      Slider(
                        value: _sensitivity,
                        onChanged: (value) => setState(() => _sensitivity = value),
                        divisions: 10,
                        label: '${(_sensitivity * 100).round()}%',
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _ActionChip(label: 'Backtest', icon: FontAwesomeIcons.clockRotateLeft, onTap: _runSimulation),
                          _ActionChip(label: 'Export CSV', icon: FontAwesomeIcons.fileCsv, onTap: _runSimulation),
                          _ActionChip(label: 'Pin to watchlist', icon: FontAwesomeIcons.star, onTap: _runSimulation),
                          _ActionChip(label: 'Share insight', icon: FontAwesomeIcons.paperPlane, onTap: _runSimulation),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedReveal(
                delay: const Duration(milliseconds: 120),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Signal metrics', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, metricsConstraints) {
                          final isWide = metricsConstraints.maxWidth > 520;
                          final gridChildren = metrics.map((metric) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colors.surfaceSoft,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: colors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(metric['title'] as String,
                                      style: theme.textTheme.bodyMedium?.copyWith(color: colors.textSecondary)),
                                  const SizedBox(height: 8),
                                  Text('${metric['value']}${metric['unit']}',
                                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: (double.parse(metric['value'] as String) / 100).clamp(0.05, 0.95),
                                    backgroundColor: colors.surface,
                                    color: colors.accent,
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                          if (isWide) {
                            return Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: gridChildren
                                  .map((child) => SizedBox(
                                        width: (metricsConstraints.maxWidth - 16) / 2,
                                        child: child,
                                      ))
                                  .toList(),
                            );
                          }
                          return Column(
                            children: gridChildren
                                .map((child) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: child,
                                    ))
                                .toList(),
                          );
                        },
                      ),
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

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    return ActionChip(
      avatar: FaIcon(icon, size: 14, color: colors.textPrimary),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: colors.surfaceSoft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.border),
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({required this.icon, required this.label, required this.value, required this.color});

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 16, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall?.copyWith(color: color.withOpacity(0.9))),
                Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
