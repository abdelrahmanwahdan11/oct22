import 'dart:async';
import 'dart:math';

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
import '../../widgets/components/feature_showcase.dart';
import '../shared/tradex_bottom_nav.dart';

class PortfolioHomeScreen extends StatefulWidget {
  const PortfolioHomeScreen({super.key});

  @override
  State<PortfolioHomeScreen> createState() => _PortfolioHomeScreenState();
}

class _PortfolioHomeScreenState extends State<PortfolioHomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _autoRefreshTimer;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _autoRefreshTimer?.cancel();
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
    if (_searchController.text != market.searchQuery) {
      _searchController.value = TextEditingValue(
        text: market.searchQuery,
        selection: TextSelection.collapsed(offset: market.searchQuery.length),
      );
    }

    _autoRefreshTimer ??= Timer.periodic(const Duration(minutes: 1), (_) {
      final portfolioCtrl = context.readController<PortfolioController>();
      final marketCtrl = context.readController<MarketController>();
      unawaited(_refresh(portfolioCtrl, marketCtrl));
    });

    final size = MediaQuery.of(context).size;
    final maxWidth = size.width >= 1200
        ? 1040.0
        : size.width >= 900
            ? 920.0
            : size.width >= 600
                ? 780.0
                : size.width;
    final double basePadding;
    if (size.width > maxWidth) {
      basePadding = max((size.width - maxWidth) / 2, 24.0);
    } else {
      basePadding = 24.0;
    }
    EdgeInsetsGeometry horizontalPadding([double extra = 0]) =>
        EdgeInsets.symmetric(horizontal: basePadding + extra);
    Widget wrapContent(Widget child) {
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('app_name')),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('ai.hub'),
            icon: const FaIcon(FontAwesomeIcons.robot),
            tooltip: strings.t('ai_insights'),
          ),
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
              padding: horizontalPadding(),
              sliver: SliverToBoxAdapter(
                child: wrapContent(
                  HeaderBalance(
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
            ),
            SliverPadding(
              padding: horizontalPadding(),
              sliver: SliverToBoxAdapter(
                child: wrapContent(
                  Row(
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
            ),
            SliverPadding(
              padding: horizontalPadding(),
              sliver: SliverToBoxAdapter(
                child: wrapContent(
                  SearchBarDark(
                  hintText: strings.t('search_hint'),
                  controller: _searchController,
                  onChanged: (value) => market.setSearchQuery(value),
                  onFilters: () => Navigator.of(context).pushNamed('filters.sheet'),
                ),
              ),
            ),
            SliverPadding(
              padding: horizontalPadding(),
              sliver: SliverToBoxAdapter(
                child: wrapContent(
                  Text(strings.t('positions'),
                      style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            SliverPadding(
              padding: horizontalPadding(),
              sliver: SliverToBoxAdapter(
                child: wrapContent(
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
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
                    itemCount: portfolio.positions.length + 1,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: horizontalPadding(),
              sliver: SliverToBoxAdapter(
                child: wrapContent(
                  Text(strings.t('tokens_stocks'),
                      style: Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            SliverPadding(
              padding: horizontalPadding(),
              sliver: SliverToBoxAdapter(
                child: wrapContent(
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
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
                    itemCount: market.top.length + 1,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: horizontalPadding(),
              sliver: SliverToBoxAdapter(
                child: wrapContent(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.t('pro_features'),
                        style:
                            Theme.of(context).textTheme.h2.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),
                      const FeatureShowcase(),
                    ],
                  ),
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
