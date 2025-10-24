import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/properties_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/animations.dart';
import '../../data/mock/app_content.dart';
import '../../widgets/components/app_bottom_navigation.dart';
import '../../widgets/components/pill_tabs.dart';
import '../../widgets/components/promo_info_card.dart';
import '../../widgets/components/property_card.dart';
import '../../widgets/components/search_bar.dart';
import '../../widgets/components/filter_chips.dart';
import '../../widgets/components/stat_pill.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PropertiesController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = NotifierProvider.of<PropertiesController>(context);
    if (_controller != controller) {
      _controller?.scrollController.removeListener(_onScroll);
      _controller = controller;
      controller.scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.scrollController.position.pixels >
        controller.scrollController.position.maxScrollExtent - 120) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _controller?.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    final properties = NotifierProvider.of<PropertiesController>(context);
    final auth = NotifierProvider.of<AuthController>(context);
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width >= 1200
        ? 80.0
        : width >= 900
            ? 48.0
            : width >= 600
                ? 28.0
                : 20.0;
    final featuredHeight = width > 900 ? 300.0 : 260.0;
    final bool isGrid = width >= 900;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('app_name')),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.gear, size: 18),
            onPressed: () => Navigator.of(context).pushNamed('settings'),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell, size: 18),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(current: 'home'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('property.submit'),
        icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
        label: Text(strings.t('add_property')),
      ),
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: settings.isDarkMode),
        child: RefreshIndicator(
          onRefresh: properties.refresh,
          child: CustomScrollView(
            controller: properties.scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        '${strings.t('hello_user')} ${auth.user?.name ?? 'Guest'}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ).fadeMove(),
                      const SizedBox(height: 4),
                      Text(
                        strings.t('daily_summary'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                            ),
                      ).fadeMove(delay: 40),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SearchBarWidget()),
              SliverToBoxAdapter(child: FilterChipsRow()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: PillTabs(onChanged: (_) {}),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final stat in AppContent.marketStats)
                        StatPill(
                          label: stat['label']!,
                          value: stat['value']!,
                          trend: double.tryParse(stat['trend'] ?? '0') ?? 0,
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: PromoInfoCard(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 12),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      for (final query in AppContent.trendingSearches)
                        ActionChip(
                          label: Text(query),
                          onPressed: () {
                            properties.setSearchQuery(query);
                            properties.registerSearch(query);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('featured_now')),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: featuredHeight,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => PropertyCard(
                      property: properties.featured[index],
                      index: index,
                    ),
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemCount: properties.featured.length,
                  ),
                ),
              ),
              if (properties.recommended.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 12),
                    child: _SectionHeader(title: strings.t('recommended_for_you')),
                  ),
                ),
              if (properties.recommended.isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: featuredHeight - 40,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => PropertyCard(
                        property: properties.recommended[index],
                        index: index,
                      ),
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemCount: properties.recommended.length,
                    ),
                  ),
                ),
              if (properties.recentlyViewed.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 12),
                    child: _SectionHeader(title: strings.t('recently_viewed')),
                  ),
                ),
              if (properties.recentlyViewed.isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: featuredHeight - 60,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => PropertyCard(
                        property: properties.recentlyViewed[index],
                        index: index,
                      ),
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemCount: properties.recentlyViewed.length,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('market_insights')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final insight in AppContent.marketInsights)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(18),
                          decoration:
                              AppDecorations.glassCard(dark: settings.isDarkMode),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                insight['title']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                insight['body']!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('virtual_tours')),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final tour = AppContent.virtualTours[index];
                      return Container(
                        width: 260,
                        decoration: AppDecorations.glassCard(dark: settings.isDarkMode),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                tour['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.0),
                                      Colors.black.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tour['title']!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      tour['duration']!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemCount: AppContent.virtualTours.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('neighborhood_spotlight')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final hood in AppContent.neighborhoodSpotlights)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration:
                              AppDecorations.sectionSurface(dark: settings.isDarkMode),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hood['title']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                hood['subtitle']!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('finance_programs')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final program in AppContent.financePrograms)
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.handHoldingDollar, size: 18),
                          title: Text(program['title']!),
                          subtitle: Text(program['subtitle']!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('service_directory')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final service in AppContent.serviceDirectory)
                        ListTile(
                          leading: FaIcon(
                            AppIcons.map[service['icon']] ?? FontAwesomeIcons.screwdriverWrench,
                            size: 18,
                          ),
                          title: Text(service['title']!),
                          subtitle: Text(service['subtitle']!),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('community_events')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final event in AppContent.communityEvents)
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.calendarCheck, size: 18),
                          title: Text(event['title']!),
                          subtitle: Text('${event['date']} · ${event['location']}'),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('investment_tips')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final tip in AppContent.investmentTips)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(18),
                          decoration:
                              AppDecorations.glassCard(dark: settings.isDarkMode),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip['title']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                tip['body']!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('sustainability_highlights')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final item in AppContent.sustainabilityHighlights)
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.leaf, size: 18),
                          title: Text(item['title']!),
                          subtitle: Text(item['body']!),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('safety_reminders')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final item in AppContent.safetyReminders)
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.shieldHalved, size: 18),
                          title: Text(item['title']!),
                          subtitle: Text(item['body']!),
                        ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 16),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(title: strings.t('suggested_list')),
                ),
              ),
              if (properties.loading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (isGrid)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= properties.feed.length) {
                          return properties.loadingMore
                              ? const Center(child: CircularProgressIndicator())
                              : const SizedBox.shrink();
                        }
                        final property = properties.feed[index];
                        return PropertyCard(property: property, index: index);
                      },
                      childCount: properties.feed.length + (properties.loadingMore ? 1 : 0),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width >= 1300 ? 3 : 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.75,
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= properties.feed.length) {
                        return properties.loadingMore
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }
                      final property = properties.feed[index];
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                            horizontalPadding, 0, horizontalPadding, 16),
                        child: PropertyCard(property: property, index: index),
                      );
                    },
                    childCount: properties.feed.length + 1,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        TextButton(
          onPressed: () {},
          child: Text(AppLocalizations.of(context).t('see_all')),
        ),
      ],
    ).fadeMove();
  }
}

class AppIcons {
  static const Map<String, IconData> map = {
    'wand-magic-sparkles': FontAwesomeIcons.wandMagicSparkles,
    'house-signal': FontAwesomeIcons.houseSignal,
    'truck-fast': FontAwesomeIcons.truckFast,
  };
}
