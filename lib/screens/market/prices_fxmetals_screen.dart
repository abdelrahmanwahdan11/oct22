import 'package:flutter/material.dart';

import '../../controllers/fx_commodities_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../widgets/components/commodity_tile.dart';
import '../../widgets/components/fx_price_tile.dart';
import '../../widgets/components/timeframe_chips.dart';

class PricesFxMetalsScreen extends StatefulWidget {
  const PricesFxMetalsScreen({super.key});

  @override
  State<PricesFxMetalsScreen> createState() => _PricesFxMetalsScreenState();
}

class _PricesFxMetalsScreenState extends State<PricesFxMetalsScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = NotifierProvider.of<FxCommoditiesController>(context);
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('fx_commodities'))),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refresh();
        },
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            const TimeframeChips(),
            const SizedBox(height: 24),
            Text(strings.t('currencies'),
                style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...controller.pairs.map(
              (pair) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FxPriceTile(pair: pair),
              ),
            ),
            if (controller.hasMorePairs)
              TextButton(
                onPressed: () => controller.loadMorePairs(),
                child: const Text('Load more'),
              ),
            const SizedBox(height: 24),
            Text(strings.t('gold'),
                style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...controller.gold.map(
              (commodity) => CommodityTile(commodity: commodity),
            ),
            const SizedBox(height: 24),
            Text(strings.t('silver'),
                style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...controller.silver.map(
              (commodity) => CommodityTile(commodity: commodity),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
