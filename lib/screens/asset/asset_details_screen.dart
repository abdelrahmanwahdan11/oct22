import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/market_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/components/bottom_capsule_bar.dart';
import '../../widgets/components/chart_full.dart';
import '../../widgets/components/timeframe_chips.dart';

class AssetDetailsScreen extends StatelessWidget {
  const AssetDetailsScreen({super.key, required this.assetId});

  final String assetId;

  List<double> _generatePoints(double basePrice) {
    final random = Random(assetId.hashCode);
    final points = <double>[];
    var value = basePrice;
    for (var i = 0; i < 32; i++) {
      final delta = (random.nextDouble() - 0.5) * basePrice * 0.01;
      value = (value + delta).clamp(basePrice * 0.8, basePrice * 1.2);
      points.add(value);
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final market = NotifierProvider.of<MarketController>(context);
    final strings = AppLocalizations.of(context);
    final item = market.findAssetQuote(assetId);
    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Asset not found')),
      );
    }
    final colors = TradeXTheme.colorsOf(context);
    final points = _generatePoints(item.quote.price);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.asset.symbol),
        actions: [
          IconButton(
            onPressed: () => market.toggleWatch(item.asset.id),
            icon: Icon(
              market.isWatched(item.asset.id)
                  ? Icons.star
                  : Icons.star_border,
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Hero(
                tag: 'asset_image_${item.asset.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(item.asset.image, height: 72, width: 72, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.asset.name,
                      style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(item.asset.symbol, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ).animate().fadeIn(280.ms).moveY(begin: 16, end: 0),
          const SizedBox(height: 24),
          Text(formatCurrency(item.quote.price),
              style: Theme.of(context).textTheme.display.copyWith(fontSize: 40)),
          const SizedBox(height: 12),
          Text(formatChangePct(item.quote.changePct),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: item.quote.changePct >= 0 ? colors.profit : colors.loss)),
          const SizedBox(height: 24),
          const TimeframeChips(),
          const SizedBox(height: 24),
          ChartFull(points: points, isGain: item.quote.changePct >= 0),
          const SizedBox(height: 24),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.6,
            ),
            children: [
              _StatTile(label: 'Open', value: formatCurrency(item.quote.open)),
              _StatTile(label: 'High', value: formatCurrency(item.quote.high)),
              _StatTile(label: 'Low', value: formatCurrency(item.quote.low)),
              _StatTile(label: 'Volume', value: formatVolume(item.quote.volume)),
            ],
          ),
          const SizedBox(height: 32),
          BottomCapsuleBar(
            onBuy: () => Navigator.of(context)
                .pushNamed('order.sheet', arguments: {'assetId': item.asset.id, 'side': 'buy'}),
            onSell: () => Navigator.of(context)
                .pushNamed('order.sheet', arguments: {'assetId': item.asset.id, 'side': 'sell'}),
            onExchange: () => Navigator.of(context).pushNamed('transfer.exchange'),
            buyLabel: strings.t('buy'),
            sellLabel: strings.t('sell'),
            exchangeLabel: strings.t('exchange'),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.caption?.copyWith(color: colors.textSecondary)),
          const SizedBox(height: 12),
          Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
