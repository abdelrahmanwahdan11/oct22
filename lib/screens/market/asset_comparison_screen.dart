import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/market_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/controller_scope.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/asset.dart' show AssetQuote;

class AssetComparisonScreen extends StatefulWidget {
  const AssetComparisonScreen({super.key});

  @override
  State<AssetComparisonScreen> createState() => _AssetComparisonScreenState();
}

class _AssetComparisonScreenState extends State<AssetComparisonScreen> {
  final List<String?> _selectedAssets = [null, null];
  bool _initialized = false;

  void _addSlot() {
    if (_selectedAssets.length >= 3) return;
    setState(() => _selectedAssets.add(null));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final market = context.readController<MarketController>();
    final allAssets = market.allAssets;
    if (allAssets.isNotEmpty) {
      _selectedAssets[0] = allAssets.first.id;
      if (allAssets.length > 1) {
        _selectedAssets[1] = allAssets[1].id;
      }
    }
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final market = context.watchController<MarketController>();
    final strings = AppLocalizations.of(context);
    final colors = TradeXTheme.colorsOf(context);
    final assets = market.allAssets;
    final dropdownItems = assets
        .map(
          (asset) => DropdownMenuItem<String>(
            value: asset.id,
            child: Text('${asset.symbol} — ${asset.name}'),
          ),
        )
        .toList();

    final comparisonCards = _selectedAssets
        .whereType<String>()
        .map(market.assetQuote)
        .whereType<AssetQuote>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('compare_assets')),
        actions: [
          IconButton(
            onPressed: _selectedAssets.length < 3 ? _addSlot : null,
            icon: const FaIcon(FontAwesomeIcons.plus),
            tooltip: strings.t('compare_add_asset'),
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
              Text(strings.t('compare_assets_headline'),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold))
                .animate()
                .fadeIn()
                .moveY(begin: 16, end: 0),
              const SizedBox(height: 12),
              Text(strings.t('compare_assets_subtitle'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
              const SizedBox(height: 24),
              ...List.generate(_selectedAssets.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedAssets[index],
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: strings
                          .t('compare_assets_picker')
                          .replaceAll('{{index}}', '${index + 1}'),
                    ),
                    items: dropdownItems,
                    onChanged: (value) {
                      setState(() => _selectedAssets[index] = value);
                    },
                  ),
                );
              }),
              if (_selectedAssets.length < 3)
                OutlinedButton.icon(
                  onPressed: _addSlot,
                  icon: const FaIcon(FontAwesomeIcons.plus),
                  label: Text(strings.t('compare_add_asset')),
                ),
              const SizedBox(height: 32),
              if (comparisonCards.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(strings.t('compare_assets_empty'),
                      style: Theme.of(context).textTheme.bodyMedium),
                )
              else
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final assetQuote in comparisonCards)
                      _ComparisonCard(
                        assetQuote: assetQuote,
                        colors: colors,
                      ).animate(interval: 60.ms).fadeIn().scale(begin: 0.98, end: 1),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.assetQuote, required this.colors});

  final AssetQuote assetQuote;
  final TradeXColors colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quote = assetQuote.quote;
    final changeColor = quote.changePct >= 0 ? colors.profit : colors.loss;
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
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
          _StatRow(
            label: AppLocalizations.of(context).t('price'),
            value: '${quote.price.toStringAsFixed(2)} ${assetQuote.asset.currency}',
          ),
          _StatRow(
            label: AppLocalizations.of(context).t('open'),
            value: quote.open.toStringAsFixed(2),
          ),
          _StatRow(
            label: AppLocalizations.of(context).t('high'),
            value: quote.high.toStringAsFixed(2),
          ),
          _StatRow(
            label: AppLocalizations.of(context).t('low'),
            value: quote.low.toStringAsFixed(2),
          ),
          _StatRow(
            label: AppLocalizations.of(context).t('volume'),
            value: _formatNumber(quote.volume),
          ),
          _StatRow(
            label: AppLocalizations.of(context).t('market_cap'),
            value: _formatNumber(quote.marketCap),
          ),
        ],
      ),
    );
  }

  String _formatNumber(num value) {
    if (value >= 1e12) return '${(value / 1e12).toStringAsFixed(2)}T';
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(2)}B';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(2)}M';
    if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(2)}K';
    return value.toStringAsFixed(2);
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
