import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/market_controller.dart';
import '../../controllers/portfolio_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/controller_scope.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/components/asset_row.dart';
import '../../widgets/components/header_balance.dart';
import '../../widgets/components/position_row.dart';
import '../../widgets/components/search_bar_dark.dart';
import '../shared/tradex_bottom_nav.dart';

class PortfolioHomeScreen extends StatefulWidget {
  const PortfolioHomeScreen({super.key});

  @override
  State<PortfolioHomeScreen> createState() => _PortfolioHomeScreenState();
}

class _PortfolioHomeScreenState extends State<PortfolioHomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh(PortfolioController portfolio, MarketController market) async {
    await Future.wait([portfolio.refresh(), market.refresh()]);
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watchController<PortfolioController>();
    final market = context.watchController<MarketController>();
    final strings = AppLocalizations.of(context);
    final colors = TradeXTheme.colorsOf(context);
    _searchController.text = market.searchQuery;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('app_name')),
        actions: [
          IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.bell)),
          IconButton(onPressed: () => Navigator.of(context).pushNamed('account'), icon: const FaIcon(FontAwesomeIcons.gear)),
        ],
      ),
      bottomNavigationBar: const TradeXBottomNav(currentIndex: 0),
      body: RefreshIndicator(
        color: colors.accent,
        onRefresh: () => _refresh(portfolio, market),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: HeaderBalance(
                  title: 'Total Balance',
                  value: formatCurrency(portfolio.totalBalance, compact: true),
                  actions: [
                    HeaderAction(
                      icon: FontAwesomeIcons.circleArrowDown,
                      label: strings.t('receive'),
                      onTap: () => Navigator.of(context).pushNamed('transfer.receive'),
                    ),
                    HeaderAction(
                      icon: FontAwesomeIcons.rightLeft,
                      label: strings.t('exchange'),
                      onTap: () => Navigator.of(context).pushNamed('transfer.exchange'),
                    ),
                    HeaderAction(
                      icon: FontAwesomeIcons.circleInfo,
                      label: strings.t('recent_trades'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed('transfer.send'),
                        icon: const FaIcon(FontAwesomeIcons.paperPlane),
                        label: Text(strings.t('send')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed('transfer.receive'),
                        icon: const FaIcon(FontAwesomeIcons.download),
                        label: Text(strings.t('receive')),
                      ),
                    ),
                  ],
                ).animate().fadeIn(280.ms).moveY(begin: 16, end: 0),
              ),
            ),
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
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Text(strings.t('positions'),
                    style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= portfolio.positions.length) {
                      if (portfolio.hasMore && !portfolio.isLoadingMore) {
                        portfolio.loadMore();
                      }
                      if (portfolio.isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                    final position = portfolio.positions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PositionRow(
                        position: position,
                        onBuy: () => Navigator.of(context).pushNamed('order.sheet',
                            arguments: {'assetId': position.assetId, 'side': 'buy'}),
                        onSell: () => Navigator.of(context).pushNamed('order.sheet',
                            arguments: {'assetId': position.assetId, 'side': 'sell'}),
                      ),
                    );
                  },
                  childCount: portfolio.positions.length + 1,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Text(strings.t('tokens_stocks'),
                    style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= market.top.length) {
                      if (market.hasMoreTop && !market.isLoadingMoreTop) {
                        market.loadMoreTop();
                      }
                      if (market.isLoadingMoreTop) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                    final item = market.top[index];
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
                  },
                  childCount: market.top.length + 1,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
