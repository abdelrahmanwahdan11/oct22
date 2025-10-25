import 'package:flutter/material.dart';

import '../../controllers/market_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../widgets/components/asset_row.dart';
import '../../widgets/components/search_bar_dark.dart';

class MarketSearchScreen extends StatefulWidget {
  const MarketSearchScreen({super.key});

  @override
  State<MarketSearchScreen> createState() => _MarketSearchScreenState();
}

class _MarketSearchScreenState extends State<MarketSearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final market = NotifierProvider.read<MarketController>(context);
    _controller.text = market.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    final market = NotifierProvider.of<MarketController>(context);
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('search'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SearchBarDark(
            hintText: strings.t('search_hint'),
            controller: _controller,
            onChanged: (value) => market.setSearchQuery(value),
          ),
          const SizedBox(height: 24),
          ...market.top.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AssetRow(
                asset: item.asset,
                quote: item.quote,
                onTap: () => Navigator.of(context)
                    .pushNamed('asset.details', arguments: item.asset.id),
                onToggleWatch: () => market.toggleWatch(item.asset.id),
                isWatched: market.isWatched(item.asset.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
