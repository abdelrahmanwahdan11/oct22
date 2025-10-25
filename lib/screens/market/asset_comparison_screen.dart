import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/market_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/controller_scope.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/asset.dart' show AssetQuote;
import '../../widgets/animations/animated_reveal.dart';
import '../../widgets/components/chart_mini.dart';

class AssetComparisonScreen extends StatefulWidget {
  const AssetComparisonScreen({super.key});

  @override
  State<AssetComparisonScreen> createState() => _AssetComparisonScreenState();
}

class _AssetComparisonScreenState extends State<AssetComparisonScreen> {
  final List<String?> _selectedAssets = [null, null];
  final ValueNotifier<int> _timeframe = ValueNotifier<int>(0);
  bool _initialized = false;
  bool _normalizeSeries = true;
  bool _showAlpha = true;

  static const _timeframes = ['1D', '1W', '1M', '6M'];

  final Map<String, List<double>> _seriesCache = {};

  void _addSlot() {
    if (_selectedAssets.length >= 4) return;
    setState(() => _selectedAssets.add(null));
  }

  void _primeDefaults(MarketController market) {
    if (_initialized) return;
    final allAssets = market.allAssets;
    if (allAssets.isNotEmpty) {
      _selectedAssets[0] = allAssets.first.id;
      if (allAssets.length > 1) {
        _selectedAssets[1] = allAssets[1].id;
      }
    }
    _initialized = true;
  }

  List<double> _seriesFor(String assetId, int timeframeIndex) {
    final key = '$assetId-$timeframeIndex-${_normalizeSeries ? 'n' : 'r'}';
    final cached = _seriesCache[key];
    if (cached != null) return cached;
    final random = math.Random(assetId.hashCode + timeframeIndex * 37);
    final base = 100 + random.nextDouble() * 20;
    var value = base;
    final points = <double>[];
    for (var i = 0; i < 60; i++) {
      final drift = (random.nextDouble() - 0.5) * base * 0.02;
      value = math.max(2, value + drift);
      points.add(_normalizeSeries ? (value / base) * 100 : value);
    }
    _seriesCache[key] = points;
    return points;
  }

  Map<String, double> _alphaFor(AssetQuote quote) {
    final pct = quote.quote.changePct;
    final volatility = (quote.quote.high - quote.quote.low).abs() / quote.quote.price * 100;
    final efficiency = quote.quote.volume == 0 ? 0 : quote.quote.marketCap / quote.quote.volume / 1000000;
    return {
      'pct': pct,
      'volatility': volatility,
      'efficiency': efficiency,
    };
  }

  @override
  void dispose() {
    _timeframe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final market = context.watchController<MarketController>();
    _primeDefaults(market);
    final strings = AppLocalizations.of(context);
    final colors = TradeXTheme.colorsOf(context);
    final assets = market.allAssets;
    final dropdownItems = assets
        .map((asset) => DropdownMenuItem<String>(value: asset.id, child: Text('${asset.symbol} — ${asset.name}')))
        .toList();

    final comparisonCards = _selectedAssets
        .whereType<String>()
        .map(market.assetQuote)
        .whereType<AssetQuote>()
        .toList();

    final chartSeries = <String, List<double>>{};
    for (final quote in comparisonCards) {
      chartSeries[quote.asset.symbol] = _seriesFor(quote.asset.id, _timeframe.value);
    }

    final palette = [colors.accent, colors.profit, colors.loss, colors.muted];

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('compare_assets')),
        actions: [
          IconButton(
            onPressed: _selectedAssets.length < 4 ? _addSlot : null,
            icon: const FaIcon(FontAwesomeIcons.plus),
            tooltip: strings.t('compare_add_asset'),
          ),
          IconButton(
            onPressed: () => setState(() => _seriesCache.clear()),
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
            tooltip: strings.t('refresh'),
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
          return ListView(
            padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 40),
            children: [
              AnimatedReveal(
                child: Text(
                  strings.t('compare_assets_headline'),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedReveal(
                delay: const Duration(milliseconds: 40),
                child: Text(
                  strings.t('compare_assets_subtitle'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedReveal(
                delay: const Duration(milliseconds: 80),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(_selectedAssets.length, (index) {
                    return SizedBox(
                      width: constraints.maxWidth < 640 ? double.infinity : (maxWidth - 16) / 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedAssets[index],
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: strings
                              .t('compare_assets_picker')
                              .replaceAll('{{index}}', '${index + 1}'),
                        ),
                        items: dropdownItems,
                        onChanged: (value) => setState(() => _selectedAssets[index] = value),
                      ),
                    );
                  }),
                ),
              ),
              if (_selectedAssets.length < 4)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: OutlinedButton.icon(
                    onPressed: _addSlot,
                    icon: const FaIcon(FontAwesomeIcons.plus),
                    label: Text(strings.t('compare_add_asset')),
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
                      Row(
                        children: [
                          Text(
                            strings.t('series_controls'),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          Switch.adaptive(
                            value: _normalizeSeries,
                            onChanged: (value) => setState(() {
                              _normalizeSeries = value;
                              _seriesCache.clear();
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(strings.t('normalize')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<int>(
                        valueListenable: _timeframe,
                        builder: (context, value, _) {
                          return SegmentedButton<int>(
                            segments: List.generate(
                              _timeframes.length,
                              (index) => ButtonSegment(value: index, label: Text(_timeframes[index])),
                            ),
                            selected: {value},
                            onSelectionChanged: (selection) {
                              _timeframe.value = selection.first;
                              setState(() {});
                            },
                            showSelectedIcon: false,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      if (chartSeries.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.center,
                          child: Text(strings.t('compare_assets_empty'), style: Theme.of(context).textTheme.bodyMedium),
                        )
                      else
                        _ComparisonChart(series: chartSeries, colors: palette, showAlpha: _showAlpha),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _showAlpha,
                        onChanged: (value) => setState(() => _showAlpha = value),
                        title: Text(strings.t('overlay_alpha_insights')),
                        subtitle: Text(strings.t('overlay_alpha_insights_sub')),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (comparisonCards.isNotEmpty)
                AnimatedReveal(
                  delay: const Duration(milliseconds: 160),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (var i = 0; i < comparisonCards.length; i++)
                        _ComparisonCard(
                          assetQuote: comparisonCards[i],
                          colors: colors,
                          accent: palette[i % palette.length],
                          alpha: _alphaFor(comparisonCards[i]),
                        ),
                    ],
                  ),
                ),
              if (comparisonCards.length >= 2) ...[
                const SizedBox(height: 24),
                AnimatedReveal(
                  delay: const Duration(milliseconds: 200),
                  child: _ComparisonTable(cards: comparisonCards, colors: colors),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.assetQuote,
    required this.colors,
    required this.accent,
    required this.alpha,
  });

  final AssetQuote assetQuote;
  final TradeXColors colors;
  final Color accent;
  final Map<String, double> alpha;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppLocalizations.of(context);
    final quote = assetQuote.quote;
    final changeColor = quote.changePct >= 0 ? colors.profit : colors.loss;
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(assetQuote.asset.image),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(assetQuote.asset.name,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    Text(assetQuote.asset.symbol,
                        style: theme.textTheme.bodySmall?.copyWith(color: colors.muted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${quote.changePct >= 0 ? '+' : ''}${quote.changePct.toStringAsFixed(2)}%',
                  style: theme.textTheme.bodySmall?.copyWith(color: changeColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ChartMini(points: [quote.open, quote.price, quote.high], isGain: quote.price >= quote.open),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(strings.t('price'),
                      style: theme.textTheme.caption?.copyWith(color: colors.textSecondary)),
                  Text('\$${quote.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: colors.border),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings.t('change_pct'),
                        style: theme.textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
                    Text('${alpha['pct']!.toStringAsFixed(2)}%',
                        style: theme.textTheme.titleMedium?.copyWith(color: accent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings.t('volatility'),
                        style: theme.textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
                    Text('${alpha['volatility']!.toStringAsFixed(1)}%',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${strings.t('efficiency')} ${alpha['efficiency']!.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
          LinearProgressIndicator(
            value: (alpha['efficiency']!.abs() / 10).clamp(0.05, 0.95),
            backgroundColor: colors.surfaceSoft,
            color: accent,
          ),
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.cards, required this.colors});

  final List<AssetQuote> cards;
  final TradeXColors colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppLocalizations.of(context);
    final headers = [strings.t('metric'), ...cards.map((c) => c.asset.symbol)];
    final rows = [
      [strings.t('open'), ...cards.map((c) => c.quote.open.toStringAsFixed(2))],
      [strings.t('high'), ...cards.map((c) => c.quote.high.toStringAsFixed(2))],
      [strings.t('low'), ...cards.map((c) => c.quote.low.toStringAsFixed(2))],
      [strings.t('volume'), ...cards.map((c) => c.quote.volume.toStringAsFixed(0))],
      [strings.t('market_cap'), ...cards.map((c) => c.quote.marketCap.toStringAsFixed(0))],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: headers
              .map((header) => DataColumn(
                    label: Text(header, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                  ))
              .toList(),
          rows: rows
              .map(
                (row) => DataRow(
                  cells: row
                      .map(
                        (value) => DataCell(
                          SizedBox(
                            width: 140,
                            child: Text(
                              value,
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ComparisonChart extends StatelessWidget {
  const _ComparisonChart({required this.series, required this.colors, required this.showAlpha});

  final Map<String, List<double>> series;
  final List<Color> colors;
  final bool showAlpha;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: CustomPaint(
            painter: _ComparisonChartPainter(series: series, colors: colors, showAlpha: showAlpha),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (var i = 0; i < series.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(series.keys.elementAt(i), style: theme.textTheme.bodySmall),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _ComparisonChartPainter extends CustomPainter {
  _ComparisonChartPainter({required this.series, required this.colors, required this.showAlpha});

  final Map<String, List<double>> series;
  final List<Color> colors;
  final bool showAlpha;

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;
    final allValues = series.values.expand((points) => points).toList();
    final minValue = allValues.reduce(math.min);
    final maxValue = allValues.reduce(math.max);
    final range = (maxValue - minValue).abs() < 0.001 ? 1.0 : maxValue - minValue;

    final gridPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var i = 0; i <= 4; i++) {
      final dy = size.height * i / 4;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    var index = 0;
    series.forEach((symbol, points) {
      final color = colors[index % colors.length];
      final offsets = <Offset>[];
      for (var i = 0; i < points.length; i++) {
        final x = size.width * i / (points.length - 1);
        final y = size.height - ((points[i] - minValue) / range) * size.height;
        offsets.add(Offset(x, y));
      }

      final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
      for (var i = 1; i < offsets.length; i++) {
        final prev = offsets[i - 1];
        final current = offsets[i];
        final control1 = Offset((prev.dx + current.dx) / 2, prev.dy);
        final control2 = Offset((prev.dx + current.dx) / 2, current.dy);
        path.cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, current.dx, current.dy);
      }

      if (showAlpha) {
        final fillPath = Path.from(path)
          ..lineTo(offsets.last.dx, size.height)
          ..lineTo(offsets.first.dx, size.height)
          ..close();
        final fillPaint = Paint()
          ..shader = LinearGradient(
            colors: [color.withOpacity(0.18), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;
        canvas.drawPath(fillPath, fillPaint);
      }

      final strokePaint = Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, strokePaint);

      for (final offset in offsets) {
        canvas.drawCircle(offset, 3, Paint()..color = color);
      }

      index += 1;
    });
  }

  @override
  bool shouldRepaint(covariant _ComparisonChartPainter oldDelegate) {
    return oldDelegate.series != series || oldDelegate.showAlpha != showAlpha;
  }
}
