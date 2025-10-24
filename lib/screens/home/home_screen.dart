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
  late final ScrollController _scrollController;
  double _budget = 350000;
  final Set<int> _completedTasks = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final properties = NotifierProvider.read<PropertiesController>(context);
        if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 120) {
          properties.loadMore();
        }
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final properties = NotifierProvider.read<PropertiesController>(context);
      properties.ensureLoaded();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final languageCode = strings.languageCode;
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
    final monthlyEstimate = ((_budget * 0.8) / 360) * 1.035;
    final downPayment = _budget * 0.2;
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
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(strings.t('notifications_placeholder'))),
            ),
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
            controller: _scrollController,
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
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final action in AppContent.homeQuickActions)
                        ActionChip(
                          avatar: FaIcon(
                            AppIcons.map[action['icon']] ?? FontAwesomeIcons.circleDot,
                            size: 16,
                          ),
                          label: Text(AppContent.localizedText(
                              (action['label'] as Map<String, String>), languageCode)),
                          onPressed: () {
                            final route = action['route'] as String;
                            if (route == 'booking.sheet') {
                              Navigator.of(context).pushNamed(route,
                                  arguments: {'propertyId': properties.feed.isNotEmpty ? properties.feed.first.id : 'p1'});
                            } else {
                              Navigator.of(context).pushNamed(route);
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 4, horizontalPadding, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.t('home_feature_highlights'),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ).fadeMove(),
                      const SizedBox(height: 4),
                      Text(
                        strings.t('home_feature_caption'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                            ),
                      ).fadeMove(delay: 40),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final features = AppContent.homeFeatureHighlights;
                          final maxWidth = constraints.maxWidth;
                          final double tileWidth;
                          if (maxWidth >= 1100) {
                            tileWidth = (maxWidth - 48) / 3;
                          } else if (maxWidth >= 700) {
                            tileWidth = (maxWidth - 32) / 2;
                          } else {
                            tileWidth = maxWidth;
                          }
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              for (final feature in features)
                                SizedBox(
                                  width: tileWidth,
                                  child: _FeatureHighlightTile(
                                    icon: AppIcons.map[feature['icon']] ??
                                        FontAwesomeIcons.wandMagicSparkles,
                                    title: AppContent.localizedText(
                                        (feature['title'] as Map<String, String>), languageCode),
                                    body: AppContent.localizedText(
                                        (feature['body'] as Map<String, String>), languageCode),
                                    dark: settings.isDarkMode,
                                  ),
                                ),
                            ],
                          ).fadeMove(delay: 60);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _HomeFeatureCluster(
                  padding: horizontalPadding,
                  title: strings.t('home_concierge_title'),
                  subtitle: strings.t('home_concierge_caption'),
                  items: AppContent.homeConciergePrograms,
                  languageCode: languageCode,
                  dark: settings.isDarkMode,
                ),
              ),
              SliverToBoxAdapter(
                child: _HomeFeatureCluster(
                  padding: horizontalPadding,
                  title: strings.t('home_intelligence_title'),
                  subtitle: strings.t('home_intelligence_caption'),
                  items: AppContent.homeIntelligenceTiles,
                  languageCode: languageCode,
                  dark: settings.isDarkMode,
                ),
              ),
              SliverToBoxAdapter(
                child: _HomeFeatureCluster(
                  padding: horizontalPadding,
                  title: strings.t('home_lifestyle_title'),
                  subtitle: strings.t('home_lifestyle_caption'),
                  items: AppContent.homeLifestyleBoosters,
                  languageCode: languageCode,
                  dark: settings.isDarkMode,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: PillTabs(
                    onChanged: (index) {
                      if (index == 0) {
                        properties.clearLifestyle();
                      } else if (index == 1) {
                        properties.applyLifestyle('family');
                      } else {
                        properties.applyLifestyle('city');
                      }
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppDecorations.glassCard(dark: settings.isDarkMode),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(strings.t('budget_planner'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            Text('${_budget.toStringAsFixed(0)} ${strings.t('currency_short')}'),
                          ],
                        ),
                        Slider(
                          value: _budget,
                          min: 120000,
                          max: 1200000,
                          divisions: 18,
                          onChanged: (value) => setState(() => _budget = value),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(strings.t('budget_monthly_label'),
                                      style: Theme.of(context).textTheme.labelLarge),
                                  const SizedBox(height: 4),
                                  Text('${monthlyEstimate.toStringAsFixed(0)} ${strings.t('currency_short')}/m',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(strings.t('down_payment'),
                                      style: Theme.of(context).textTheme.labelLarge),
                                  const SizedBox(height: 4),
                                  Text('${downPayment.toStringAsFixed(0)} ${strings.t('currency_short')}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final advisory in AppContent.budgetAdvisories)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  leading: const FaIcon(FontAwesomeIcons.lightbulb, size: 16),
                                  title: Text(AppContent.localizedText(
                                      (advisory['title'] as Map<String, String>), languageCode)),
                                  subtitle: Text(AppContent.localizedText(
                                      (advisory['body'] as Map<String, String>), languageCode)),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                            properties.setSearchQuery(query, immediate: true);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('travel_times')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppDecorations.sectionSurface(dark: settings.isDarkMode),
                    child: Column(
                      children: [
                        for (final place in AppContent.travelTimes)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppContent.localizedText(
                                        (place['title'] as Map<String, String>), languageCode),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                _TravelTimePill(label: '🚗', value: place['car'] as int?),
                                const SizedBox(width: 8),
                                _TravelTimePill(label: '🚆', value: place['transit'] as int?),
                                const SizedBox(width: 8),
                                _TravelTimePill(label: '🚲', value: place['bike'] as int?),
                              ],
                            ),
                          ),
                      ],
                    ),
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
                      width: 260,
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
                        width: 260,
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
                        width: 260,
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
                  child: _SectionHeader(title: strings.t('renovation_tasks')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (var i = 0; i < AppContent.renovationChecklist.length; i++)
                        CheckboxListTile(
                          value: _completedTasks.contains(i),
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _completedTasks.add(i);
                              } else {
                                _completedTasks.remove(i);
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(AppContent.localizedText(
                              (AppContent.renovationChecklist[i]['title'] as Map<String, String>),
                              languageCode)),
                          subtitle: Text(AppContent.localizedText(
                              (AppContent.renovationChecklist[i]['detail'] as Map<String, String>),
                              languageCode)),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('resident_stories')),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.85),
                    itemCount: AppContent.successStories.length,
                    itemBuilder: (context, index) {
                      final story = AppContent.successStories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: AppDecorations.glassCard(dark: settings.isDarkMode),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppContent.localizedText(
                                    (story['title'] as Map<String, String>), languageCode),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppContent.localizedText(
                                    (story['body'] as Map<String, String>), languageCode),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
                  child: _SectionHeader(title: strings.t('insurance_offers')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final option in AppContent.insuranceOptions)
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.shieldHalved, size: 18),
                          title: Text(AppContent.localizedText(
                              (option['title'] as Map<String, String>), languageCode)),
                          subtitle: Text(AppContent.localizedText(
                              (option['body'] as Map<String, String>), languageCode)),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('maintenance_schedule')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final reminder in AppContent.maintenanceReminders)
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.wrench, size: 18),
                          title: Text(AppContent.localizedText(
                              (reminder['title'] as Map<String, String>), languageCode)),
                          trailing: Text(reminder['schedule'] as String),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 12),
                  child: _SectionHeader(title: strings.t('guarantee_programs')),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      for (final badge in AppContent.guaranteeBadges)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: AppDecorations.glassCard(dark: settings.isDarkMode),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppContent.localizedText(
                                  (badge['title'] as Map<String, String>), languageCode),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Text(AppContent.localizedText(
                                  (badge['body'] as Map<String, String>), languageCode)),
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
                  child: _SectionHeader(title: strings.t('top_agents')),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 160,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final agent = AppContent.topAgents[index];
                      return Container(
                        width: 220,
                        padding: const EdgeInsets.all(16),
                        decoration: AppDecorations.glassCard(dark: settings.isDarkMode),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(agent['photo'] as String),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppContent.localizedText(
                                          (agent['name'] as Map<String, String>), languageCode),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(fontWeight: FontWeight.w600)),
                                      Text(AppContent.localizedText(
                                          (agent['city'] as Map<String, String>), languageCode)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.star, size: 14, color: Colors.amber),
                                const SizedBox(width: 6),
                                Text('${agent['rating']}'),
                              ],
                            ),
                            const Spacer(),
                            FilledButton.tonal(
                              onPressed: () => Navigator.of(context).pushNamed('agent.details',
                                  arguments: agent['name']),
                              child: Text(strings.t('contact_agent')),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemCount: AppContent.topAgents.length,
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
              if (!properties.loading && properties.feed.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppDecorations.glassCard(dark: settings.isDarkMode),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.t('home_empty_title'),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            strings.t('home_empty_body'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () {
                              properties.clearLifestyle();
                            },
                            icon: const FaIcon(FontAwesomeIcons.rotateLeft, size: 16),
                            label: Text(strings.t('home_empty_reset')),
                          ),
                        ],
                      ),
                    ),
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

class _TravelTimePill extends StatelessWidget {
  const _TravelTimePill({required this.label, required this.value});

  final String label;
  final int? value;

  @override
  Widget build(BuildContext context) {
    final text = value == null || value == 0 ? '–' : '${value!}m';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          Text(text, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _FeatureHighlightTile extends StatelessWidget {
  const _FeatureHighlightTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.dark,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = dark
        ? const Color(0xFF1E2127).withOpacity(0.88)
        : theme.colorScheme.surface;
    final borderColor = theme.dividerColor.withOpacity(dark ? 0.25 : 0.18);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(16, 24, 40, 0.05),
                blurRadius: 20,
                offset: Offset(0, 14),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FaIcon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                title,
                style:
                    theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context).t('see_all'),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  FaIcon(
                    AppIcons.map['arrow-right-long'] ?? FontAwesomeIcons.arrowRightLong,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeFeatureCluster extends StatelessWidget {
  const _HomeFeatureCluster({
    required this.padding,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.languageCode,
    required this.dark,
  });

  final double padding;
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> items;
  final String languageCode;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 12, padding, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ).fadeMove(),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.72),
                ),
          ).fadeMove(delay: 40),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final double tileWidth;
              if (maxWidth >= 1200) {
                tileWidth = (maxWidth - 48) / 3;
              } else if (maxWidth >= 800) {
                tileWidth = (maxWidth - 24) / 2;
              } else {
                tileWidth = maxWidth;
              }
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < items.length; i++)
                    SizedBox(
                      width: tileWidth,
                      child: _CompactFeatureCard(
                        icon: AppIcons.map[(items[i]['icon'] as String?) ?? ''] ??
                            FontAwesomeIcons.circleDot,
                        title: AppContent.localizedText(
                          (items[i]['title'] as Map<String, String>),
                          languageCode,
                        ),
                        body: AppContent.localizedText(
                          (items[i]['body'] as Map<String, String>),
                          languageCode,
                        ),
                        dark: dark,
                        index: i,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CompactFeatureCard extends StatelessWidget {
  const _CompactFeatureCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.dark,
    required this.index,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool dark;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bubbleColor = dark ? const Color(0xFF2A2F36) : Colors.white;
    final textColor =
        theme.textTheme.bodySmall?.color?.withOpacity(dark ? 0.75 : 0.7);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context).t('feature_capture_toast')),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF14171C) : const Color(0xFFF7F7F9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: dark ? const Color(0xFF2A2F36) : const Color(0xFFE7E9EF),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(dark ? 0.14 : 0.06),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: FaIcon(
                  icon,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style:
                    theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                body,
                style: theme.textTheme.bodySmall?.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    ).fadeMove(delay: index * 20);
  }
}

class AppIcons {
  static const Map<String, IconData> map = {
    'wand-magic-sparkles': FontAwesomeIcons.wandMagicSparkles,
    'house-signal': FontAwesomeIcons.houseSignal,
    'truck-fast': FontAwesomeIcons.truckFast,
    'plus': FontAwesomeIcons.plus,
    'heart': FontAwesomeIcons.heart,
    'scale-balanced': FontAwesomeIcons.scaleBalanced,
    'calendar-check': FontAwesomeIcons.calendarCheck,
    'file-lines': FontAwesomeIcons.fileLines,
    'file-shield': FontAwesomeIcons.fileShield,
    'book': FontAwesomeIcons.book,
    'arrow-right-long': FontAwesomeIcons.arrowRightLong,
    'rotate-left': FontAwesomeIcons.rotateLeft,
    'chart-simple': FontAwesomeIcons.chartSimple,
    'earth-europe': FontAwesomeIcons.earthEurope,
    'leaf': FontAwesomeIcons.leaf,
    'school': FontAwesomeIcons.school,
    'paw': FontAwesomeIcons.paw,
    'clipboard-check': FontAwesomeIcons.clipboardCheck,
    'handshake-simple': FontAwesomeIcons.handshakeSimple,
    'sun': FontAwesomeIcons.sun,
    'couch': FontAwesomeIcons.couch,
    'calendar-days': FontAwesomeIcons.calendarDays,
    'palette': FontAwesomeIcons.palette,
    'hand-holding-dollar': FontAwesomeIcons.handHoldingDollar,
    'circle-play': FontAwesomeIcons.circlePlay,
    'wifi': FontAwesomeIcons.wifi,
    'bell': FontAwesomeIcons.bell,
    'people-roof': FontAwesomeIcons.peopleRoof,
    'spa': FontAwesomeIcons.spa,
    'house-laptop': FontAwesomeIcons.houseLaptop,
    'ear-listen': FontAwesomeIcons.earListen,
    'square-parking': FontAwesomeIcons.squareParking,
    'boxes-stacked': FontAwesomeIcons.boxesStacked,
    'shield-heart': FontAwesomeIcons.shieldHeart,
    'shield-halved': FontAwesomeIcons.shieldHalved,
    'file-invoice': FontAwesomeIcons.fileInvoice,
    'water': FontAwesomeIcons.water,
    'chart-line': FontAwesomeIcons.chartLine,
    'list-check': FontAwesomeIcons.listCheck,
    'user-shield': FontAwesomeIcons.userShield,
    'headset': FontAwesomeIcons.headset,
    'map-location-dot': FontAwesomeIcons.mapLocationDot,
    'clipboard-list': FontAwesomeIcons.clipboardList,
    'magnifying-glass-location': FontAwesomeIcons.magnifyingGlassLocation,
    'layer-group': FontAwesomeIcons.layerGroup,
    'chart-pie': FontAwesomeIcons.chartPie,
    'clock-rotate-left': FontAwesomeIcons.clockRotateLeft,
    'satellite-dish': FontAwesomeIcons.satelliteDish,
    'table-list': FontAwesomeIcons.tableList,
    'gauge-high': FontAwesomeIcons.gaugeHigh,
    'cloud-sun': FontAwesomeIcons.cloudSun,
    'dumbbell': FontAwesomeIcons.dumbbell,
    'mug-hot': FontAwesomeIcons.mugHot,
    'seedling': FontAwesomeIcons.seedling,
    'person-hiking': FontAwesomeIcons.personHiking,
    'music': FontAwesomeIcons.music,
    'utensils': FontAwesomeIcons.utensils,
    'children': FontAwesomeIcons.children,
    'bicycle': FontAwesomeIcons.bicycle,
  };
}
