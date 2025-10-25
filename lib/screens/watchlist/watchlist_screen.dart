import 'package:flutter/material.dart';

import '../../controllers/market_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../widgets/components/asset_row.dart';
import '../shared/tradex_bottom_nav.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final market = NotifierProvider.of<MarketController>(context);
    final strings = AppLocalizations.of(context);
    final items = market.watchlistAssets;
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('watchlist'))),
      bottomNavigationBar: const TradeXBottomNav(currentIndex: 2),
      body: items.isEmpty
          ? Center(child: Text(strings.t('empty_watchlist')))
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemBuilder: (context, index) {
                final item = items[index];
                return AssetRow(
                  asset: item.asset,
                  quote: item.quote,
                  onTap: () => Navigator.of(context)
                      .pushNamed('asset.details', arguments: item.asset.id),
                  onToggleWatch: () => market.toggleWatch(item.asset.id),
                  isWatched: true,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length,
            ),
    );
  }
}
