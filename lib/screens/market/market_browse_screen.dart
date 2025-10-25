import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/market_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/controller_scope.dart';
import '../../widgets/components/asset_row.dart';
import '../../widgets/components/search_bar_dark.dart';
import '../shared/tradex_bottom_nav.dart';

class MarketBrowseScreen extends StatefulWidget {
  const MarketBrowseScreen({super.key});

  @override
  State<MarketBrowseScreen> createState() => _MarketBrowseScreenState();
}

class _MarketBrowseScreenState extends State<MarketBrowseScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _tabs = const ['All', 'Stocks', 'Crypto'];
  int _selectedTab = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final market = context.watchController<MarketController>();
    final strings = AppLocalizations.of(context);
    _searchController.text = market.searchQuery;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('market')),
        actions: [
          IconButton(onPressed: () => Navigator.of(context).pushNamed('search'), icon: const FaIcon(FontAwesomeIcons.magnifyingGlass)),
        ],
      ),
      bottomNavigationBar: const TradeXBottomNav(currentIndex: 1),
      body: RefreshIndicator(
        onRefresh: () => market.refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverToBoxAdapter(
                child: SearchBarDark(
                  hintText: strings.t('search_hint'),
                  controller: _searchController,
                  onChanged: (value) => market.setSearchQuery(value),
                  onFilters: () => Navigator.of(context).pushNamed('filters.sheet'),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Wrap(
                  spacing: 8,
                  children: List.generate(_tabs.length, (index) {
                    final label = _tabs[index];
                    final selected = index == _selectedTab;
                    return ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (_) async {
                        setState(() => _selectedTab = index);
                        final type = label == 'All'
                            ? null
                            : label.toLowerCase() == 'stocks'
                                ? 'stock'
                                : 'crypto';
                        await market.setTypeFilter(type);
                      },
                    );
                  }),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              sliver: SliverToBoxAdapter(
                child: Text(strings.t('trending'),
                    style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            if (market.trending.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 140,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = market.trending[index];
                      return SizedBox(
                        width: 240,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
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
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: market.trending.length,
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Text(strings.t('most_active'),
                    style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index >= market.mostActive.length) {
                    if (market.hasMoreActive && !market.isLoadingMoreActive) {
                      market.loadMoreActive();
                    }
                    if (market.isLoadingMoreActive) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox.shrink();
                  }
                  final item = market.mostActive[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AssetRow(
                      asset: item.asset,
                      quote: item.quote,
                      onTap: () => Navigator.of(context)
                          .pushNamed('asset.details', arguments: item.asset.id),
                      onToggleWatch: () => market.toggleWatch(item.asset.id),
                      isWatched: market.isWatched(item.asset.id),
                    ),
                  );
                }, childCount: market.mostActive.length + 1),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
